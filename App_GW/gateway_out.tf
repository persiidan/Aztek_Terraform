output "GATEWAY_FRONT_PIP" {
  value = azurerm_public_ip.pip.ip_address
}

output "GATEWAY_NAME" {
  value = azurerm_application_gateway.app_gw.name
}