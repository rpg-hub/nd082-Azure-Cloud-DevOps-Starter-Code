# variables.tf
# Author: juda@microsoft.com
# Instantiate variables for the Service Principal

variable "prefix" {  
    default = "nanod"
}

variable "tenant_id" {
    default = "cbd14134-0c59-...9-e5d3a3cb9b7e"
}

variable "client_id" {  
    default="13c8df85-dcf5-...-30a5f06a15ed"
}

variable "client_secret" {  
    default="vib3Wwc6h3L_K....j.U0yYyR7"
}

variable "subscription_id" {  
    default="4938c642-c8f0...89337969f78e"
}

variable "location" {
    description = "The Azure Region in which all resources in this example should be created."
    default = "eastus"
}

variable "username" {
  description = "enter username while running script"
}

variable "password" {
  description = "enter while running"
}












