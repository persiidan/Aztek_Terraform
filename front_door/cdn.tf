provider "azurerm" {
  features {}
}

locals {
  profile_name      = "FrontDoorProfile"
  endpoint_name     = "Aztek-PyApp-afd"
  origin_group_name = "OriginGroup"
  origin_name       = "AppServiceOrigin"
  route_name        = "Route"
}

resource "azurerm_cdn_frontdoor_profile" "front_door_profile" {
  name                = local.profile_name
  resource_group_name = var.rg_name
  sku_name            = var.afd_tier
}

resource "azurerm_cdn_frontdoor_endpoint" "endpoint" {
  name                     = local.endpoint_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.front_door_profile.id
}

resource "azurerm_cdn_frontdoor_origin_group" "origin_group" {
  name                     = local.origin_group_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.front_door_profile.id
  session_affinity_enabled = true

  health_probe {
    path                = "/"
    request_type        = "GET"
    protocol            = "Http"
    interval_in_seconds = 100
  }
  
  load_balancing {
    sample_size = 1
    successful_samples_required = 1
  }
}

resource "azurerm_cdn_frontdoor_origin" "app_gw_origin" {
  name                          = local.origin_name
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.origin_group.id

  enabled                        = true
  host_name                      = var.app_gw_pip
  http_port                      = 80
  priority                       = 1
  weight                         = 1000
  certificate_name_check_enabled = false
}

resource "azurerm_cdn_frontdoor_route" "my_route" {
  name                          = local.route_name
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.origin_group.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.app_gw_origin.id]

  supported_protocols    = ["Http"]
  patterns_to_match      = ["/*"]
  cdn_frontdoor_origin_path = "/"
  forwarding_protocol    = "HttpOnly"
  link_to_default_domain = true
  https_redirect_enabled = false
}