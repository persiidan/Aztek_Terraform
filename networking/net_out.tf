output "SUBNET_GATEWAY_ID" {
  value = azurerm_subnet.App_gateway_subnet.id
  sensitive = true
}
output "SUBNET_GATEWAY_NAME" {
  value = azurerm_subnet.App_gateway_subnet.name
}