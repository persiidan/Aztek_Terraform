
#  ---------------------------------------------
#  module for azure virtual networks and nsg
#  ---------------------------------------------

resource "azurerm_virtual_network" "Aztek_Vnet" {
  name = "Aztek_Vnet"
  location = var.location
  resource_group_name = var.rg_name
  address_space = [ "10.0.0.0/16" ]
}

resource "azurerm_subnet" "App_gateway_subnet" {
  name = "App_gateway_subnet"
  resource_group_name = var.rg_name
  virtual_network_name = azurerm_virtual_network.Aztek_Vnet.name
  address_prefixes = [ "10.0.1.0/24" ]
  service_endpoints = [ "Microsoft.Web" ]
}

# resource "azurerm_network_security_group" "App_gateway_nsg" {
#   name                = "App_gateway_nsg"
#   location            = var.location
#   resource_group_name = var.rg_name

#   security_rule {
#     name                       = "Mandatory_Port_for_gw"
#     priority                   = 100
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "*"
#     source_port_range         = "*"
#     destination_port_ranges     = ["65200-65535"]
#     source_address_prefix      = "GatewayManager"
#     destination_address_prefix = "*"
#   }

#    security_rule {
#     name                       = "Allow_Front_Door"
#     priority                   = 110
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range         = "*"
#     destination_port_range     = "80"
#     source_address_prefix      = "AzureFrontDoor.Backend"
#     destination_address_prefix = "VirtualNetwork"
#   }
# }

# resource "azurerm_subnet_network_security_group_association" "nsg_gw_subnet" {
#   subnet_id = azurerm_subnet.App_gateway_subnet.id
#   network_security_group_id = azurerm_network_security_group.App_gateway_nsg.id
# }