provider "azurerm" {
  features {}
}

#  ---------------------------------------------
#  resource groupe
#  ---------------------------------------------
resource "azurerm_resource_group" "web-RG" {
  location = var.location
  name = "Aztek-App-RG"
}
#  ---------------------------------------------
#  deploy module virtual network
#  ---------------------------------------------

module "Virtual_Network" {
  source = "./networking"
  rg_name = azurerm_resource_group.web-RG.name
  location = var.location
}

#  ---------------------------------------------
#  azure app service plan
#  ---------------------------------------------
resource "azurerm_service_plan" "service_plan" {
  name = "aztek_service_plan"
  location = var.location
  resource_group_name = azurerm_resource_group.web-RG.name
  sku_name = "P1v3"
  os_type = "Linux"
}

#  ---------------------------------------------
#  deploy module for azure monitor service (enable AutoScaling for app service plan)
#  ---------------------------------------------
module "monitoring" {
  source = "./monitoring"
  location = var.location
  rg_name = azurerm_resource_group.web-RG.name
  resource_id = azurerm_service_plan.service_plan.id
}

#  ---------------------------------------------
#  deploy module for azure app service
#  ---------------------------------------------
module "web_app" {
  source = "./web_app"
  rg_name = azurerm_resource_group.web-RG.name
  location = var.location
  service_plan_id = azurerm_service_plan.service_plan.id
  path_to_app = "app.zip" 
  app_name = "aztek-idan-python-web-app" 
  gateway_subnet_name = module.Virtual_Network.SUBNET_GATEWAY_NAME
  gateway_subnet_id = module.Virtual_Network.SUBNET_GATEWAY_ID
}

#  ---------------------------------------------
#  deploy module app gateway
#  ---------------------------------------------
module "Application_Gateway" {
  source = "./App_GW"
  app_gw_name = "app_gw"
  rg_name = azurerm_resource_group.web-RG.name
  location = var.location
  App_GW_subnet_id = module.Virtual_Network.SUBNET_GATEWAY_ID
  app_name = module.web_app.WEB_APP_NAME
}

#  ---------------------------------------------
#  deploy module CDN - front door
#  ---------------------------------------------
module "Azure_Front_Door" {
  source = "./front_door"
  rg_name = azurerm_resource_group.web-RG.name
  location = var.location
  app_gw_name = module.Application_Gateway.GATEWAY_NAME
  app_gw_pip = module.Application_Gateway.GATEWAY_FRONT_PIP
}
