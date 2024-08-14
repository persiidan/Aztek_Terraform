variable "location" {
    description = "default location for azure resources"
    type = string
}

variable "rg_name" {
    description = "name of resource group"
    type = string
}

variable "service_plan_id" {
    description = "the id of the serviceplan to use"
    type = string
}

variable "app_name" {
    description = "the wanted name of the app"
    type = string 
}

variable "path_to_app" {
    description = "path from app service module to app.zip"
    type = string
}

variable "gateway_subnet_name" {
  description = "name of app gw"
  type = string
}

variable "gateway_subnet_id" {
  description = "id of the dedicated app gw subnet"
  type = string
}