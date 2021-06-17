# variables.tf
# Author: Rajeev

variable "prefix" {  
    default = "nanod"
}

variable "tenant_id" {
    default = "cbd14134-0c59-4a68-8ae9-e5d3a3cb9b7e"
}

variable "client_id" {  
    default="13c8df85-dcf5-46cd-b697-30a5f06a15ed"
}

variable "client_secret" {  
    default="vib3Wwc6h3L_KiGm7k2z3qejkY2U0yYyR7"
}

variable "subscription_id" {  
    default="4938c642-c8f0-4edd-8f0d-89337969f78e"
}

variable "location" {
    description = "The Azure Region in which all resources in this example should be created."
    default = "eastus"
}

variable "username" {
  description = "enter user name:"
}

variable "password" {
  description = "enter user password:"
}

variable "VMCount" {
    description = "How many VMs do you want to start with (number)? default=2 max=5"
    type = number
}
