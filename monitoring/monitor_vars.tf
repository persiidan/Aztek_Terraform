variable "rg_name" {
    description = "name of resource group"
    type = string
}
variable "location" {
    description = "default location for azure resources"
    type = string
}

variable "resource_id" {
    description = "the id of the wanted resource to monitor"
    type = string
}