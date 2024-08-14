
#  ---------------------------------------------
#  module for azure app service
#  ---------------------------------------------

resource "azurerm_linux_web_app" "Web-app" {
  name = var.app_name
  location = var.location
  resource_group_name = var.rg_name
  service_plan_id = var.service_plan_id
  https_only = false
  public_network_access_enabled = true

  site_config {
    minimum_tls_version = 1.2
    use_32_bit_worker = false
    application_stack {
    python_version = 3.12
  }

  ip_restriction {
    action = "Allow"
    name = "allow-${var.gateway_subnet_name}"
    virtual_network_subnet_id = var.gateway_subnet_id
    priority = 1
  }
  
  ip_restriction {
    action = "Deny"
    name = "Deny all access"
    ip_address = "0.0.0.0/0"
    priority = 2000
  }
  }

  app_settings = {
    "SCM_DO_BUILD_DURING_DEPLOYMENT" = "true"
    "WEBSITE_RUN_FROM_PACKAGE" = 1
  }

  # deploys the app from local zip file
  provisioner "local-exec" { 
    command = "az webapp deploy --name ${self.name} --resource-group ${var.rg_name} --src-path ${var.path_to_app} --type zip"
  }
  
}
