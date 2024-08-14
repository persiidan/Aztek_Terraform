output "WEB_APP_ID" {
  value     = azurerm_linux_web_app.Web-app.id
  sensitive = true
}
output "WEB_APP_NAME" {
  value = azurerm_linux_web_app.Web-app.name
}