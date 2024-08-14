variable "location" {
    description = "default location for azure resources"
    type = string
}

variable "rg_name" {
    description = "name of resource group"
    type = string
}

variable "app_gw_name" {
  description = "name of app gw"
  type = string
}

variable "app_gw_pip" {
  description = "public ip of app gw"
  type = string
}

variable "afd_tier" {
  type = string
  description = "wanted tier of Azure Front Door Possible values include: Standard_AzureFrontDoor, Premium_AzureFrontDoor"
  default = "Standard_AzureFrontDoor"
  validation {
    condition     = contains(["Standard_AzureFrontDoor", "Premium_AzureFrontDoor"], var.afd_tier)
    error_message = "The SKU value must be one of the following: Standard_AzureFrontDoor, Premium_AzureFrontDoor."
  }
}
