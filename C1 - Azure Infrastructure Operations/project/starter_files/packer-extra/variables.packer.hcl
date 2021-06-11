//  variables.pkr.hcl

// from https://www.packer.io/guides/hcl/variables
// For those variables that you don't provide a default for, you must
// set them from the command line, a var-file, or the environment.


variable "ARM_CLIENT_ID" {
  type = string
  default = "13c8df85-dcf5-46cd-b697-30a5f06a15ed"
}

variable "ARM_CLIENT_SECRET" {
  type = string
  default = "vib3Wwc6h3L_KiGm7k2z3qejkY2U0yYyR7"
}
	
variable "ARM_SUBSCRIPTION_ID" {
  type = string
  default = "4938c642-c8f0-4edd-8f0d-89337969f78e"
}
	
variable "ARM_TENANT_ID"{
  type = string
  default = "cbd14134-0c59-4a68-8ae9-e5d3a3cb9b7e"
}
