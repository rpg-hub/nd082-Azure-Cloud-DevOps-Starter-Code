# variables.tf
# Author: Rajeev
# this file for git-hub only

#these values can be obtained from portal or are only displayed (secret) when creating Service Principal.

variable "prefix" {  
    default = "nanod"
}

variable "tenant_id" {
    default = "your_tenant_id"
}

variable "client_id" {  
    default="your_client_id"
}

variable "client_secret" {  
    default="your_client secret"
}

variable "subscription_id" {  
    default="your_subscription_id"
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
