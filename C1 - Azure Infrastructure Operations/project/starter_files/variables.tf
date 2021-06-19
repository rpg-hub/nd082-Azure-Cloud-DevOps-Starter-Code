# variables.tf
# Author: Rajeev

variable "prefix" {  
    description = "Prefix will be used in all resources like RG, VM NIC etc. to easily identify the deployement."
    default = "nanod"
}

variable "tenant_id" {
    description = "Azure tenant ID"
    default = "cbd141xxxxxxxxxa3cb9b7e"
}

variable "client_id" {  
    description = "Azure Service Principal ID"
    default="13c8xxxxxxxxxxxxxxxxx06a15ed"
}

variable "client_secret" {  
    description = "Azure secret for Service Principal"
    default="vib3WwxxxxxxxxxxxxxxxxyYyR7"
}

variable "subscription_id" {  
    description = "Azure subscription ID."
    default="4938cxxxxxxxxxxxxxx9f78e"
}

variable "location" {
    description = "The Azure Region in which all resources in this example should be created."
    default = "eastus"
}

variable "username" {
  description = "VM user name:"
  default = "adminuser"
}

variable "password" {
  description = "VM user password:"
  default = "Password123!"
}

variable "VMCount" {
    description = "How many VMs do you want to start with (number)? default=2 max=5"
    type = number
    default = 2
}
