
#  ---------------------------------------------
#  module for azure application gateway
#  ---------------------------------------------

locals {
  backend_address_pool_name = "${var.app_gw_name}-Back_end"
  frontend_ip_configuration_name = "${var.app_gw_name}-Front_end_conf"
  
  # http set of local vars
  http_setting_name = "${var.app_gw_name}-http_settings"
  http_frontend_port_name = "${var.app_gw_name}-Front_end_http"
  http_listener_name = "${var.app_gw_name}-http_listener"
  http_routing = "${var.app_gw_name}-http_role"
}

resource "azurerm_public_ip" "pip" {
  name                = "AGW_PublicIP"
  resource_group_name = var.rg_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_web_application_firewall_policy" "waf_policy_agw" {
  name = "waf_policy_agw"
  location = var.location
  resource_group_name = var.rg_name

  policy_settings {
    enabled = true
    mode = "Prevention"
    request_body_check = true
    file_upload_limit_in_mb = 100
    max_request_body_size_in_kb = 128
  }

  managed_rules {
    managed_rule_set {
      version = 3.2
    }
  }

  custom_rules {
    name = "Rule1"
    priority = 1
    rule_type = "MatchRule"

    match_conditions {
      match_variables {
        variable_name =  "RequestHeaders"
        selector = "X-Azure-FDID"
      }
      
      operator = "Any"
      negation_condition = true
    }

    action = "Block"
  }
  
}

resource "azurerm_application_gateway" "app_gw" {
  name                = var.app_gw_name
  resource_group_name = var.rg_name
  location            = var.location
  firewall_policy_id = azurerm_web_application_firewall_policy.waf_policy_agw.id

  # replaces sku.capacity when auto scale from gateway is wanted
  #
  # autoscale_configuration {
  #   min_capacity = 1
  #   max_capacity = 2
  # }

  sku {
    name = "WAF_v2"
    tier = "WAF_v2"
    capacity = 1
  }

  waf_configuration {
    enabled = true
    firewall_mode = "Prevention"
    rule_set_version = 3.2
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.pip.id
  }

  backend_address_pool {
    name =local.backend_address_pool_name
    fqdns = [ "${var.app_name}.azurewebsites.net" ]
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = var.App_GW_subnet_id
  }

  probe {
    name = var.probe_name
    host = "${var.app_name}.azurewebsites.net"
    path = "/"
    protocol = "Http"
    timeout = 30
    interval = 30
    unhealthy_threshold = 3
  }
 # ------------ http conf -----------------

  frontend_port {
    name = local.http_frontend_port_name
    port = 80
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
    probe_name = var.probe_name
    pick_host_name_from_backend_address = true
  }

  http_listener {
    name                           = local.http_listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.http_frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.http_routing
    rule_type                  = "Basic"
    http_listener_name         = local.http_listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
    priority                   = 1
  }

}