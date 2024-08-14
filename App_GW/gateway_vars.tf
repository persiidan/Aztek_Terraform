variable "location" {
    description = "default location for azure resources"
    type = string
}

variable "app_gw_name" {
  description = "name of app gw"
  type = string
}

variable "rg_name" {
    description = "name of resource group"
    type = string
}

variable "App_GW_subnet_id" {
  description = "id of the dedicated app gw subnet"
  type = string
}

variable "app_name" {
    description = "name of app for backend pool"
    type = string
}

variable "probe_name" {
    description = "name of probe"
    type = string
    default = "App_Probe"
}