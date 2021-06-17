# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

### Introduction
For this project, you will write a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.

### Getting Started
1. Clone this repository

2. Create your infrastructure as code

3. Update this README to reflect how someone would use your code.

### Dependencies
1. Create an [Azure Account](https://portal.azure.com) 
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)

### Instructions
Lets first clone the repo:
1.	clone from: https://github.com/udacity/nd082-Azure-Cloud-DevOps-Starter-Code.git
	clone to: local PC.
	$ cd /home/git-clone
	$ git clone https://github.com/udacity/nd082-Azure-Cloud-DevOps-Starter-Code.git
	
2. cd to the starter_files folder.
<pre>
	cd '/home/git-clone/nd082-Azure-Cloud-DevOps-Starter-Code/C1 - Azure Infrastructure Operations/project/starter_files'

	Using your editor of choice, edit for your setup and requirements.
		server.json		Packer template
		variables.tf		Terraform variables declaration template
		main.tf			Main Terraform template for defining state, and deployment.
</pre>

2.a: modifying variables.tf, for example:
<pre>
# variables.tf
# Author: Rajeev

variable "prefix" {  
    default = "nanod"
}

variable "tenant_id" {
    default = "your-tenant-id"
}

variable "client_id" {  
    default="your-client-id"
}

variable "client_secret" {  
    default="svc-principal-secret"
}

variable "subscription_id" {  
    default="your-subscription-id"
}

variable "location" {
    description = "The Azure Region in which all resources in this example should be created."
    default = "eastus"  ##choose your region of choice here
}

variable "username" {
  description = "enter user name:"
}

variable "password" {
  description = "enter user password:"
}

variable "VMCount" {
    description = "How many VMs do you want to start with (number)? default=2 max=5"  ## the limits are controlled in main.tf
    type = number
}
</pre>


3. To deploy using Terraform you will need a service principal. create one before hand:
<pre>
	$ az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/your-subscription-ID"
	save the output and use it in your variables.tf
</pre>
	
4. in short:
<pre>
	terraform validate						### validate your config in scripts
	terraform plan -target=azurerm_resource_group.project1		### builds RG
	terraform apply -target=azurerm_resource_group.project1		### Create in Azure
	packer validate server.json
	packer build server.json					### creating Packer VM Image in Azure
	terraform plan -out solution.plan				### checking and saving terraform site/code config
	terraform apply "solution.plan"					### deploying saved terraform site/code config to Azure.
	..try some az commands to check your resources...
	terraform destroy						### destroy the code deployed using terraform site/code config
</pre>
	run terraform and packer commands from the same folder where the scripts are.

### Output
	I am putting here my terraform deployement show status. Yours should look the same if you deploy as it is.

		$ terraform show
		# azurerm_availability_set.project1:
		resource "azurerm_availability_set" "project1" {
			id                           = "/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Compute/availabilitySets/nanod-avset"
			location                     = "eastus"
			managed                      = true
			name                         = "nanod-avset"
			platform_fault_domain_count  = 3
			platform_update_domain_count = 5
			resource_group_name          = "nanod-rg"
			tags                         = {
				"ND" = "1"
			}
		}

		# azurerm_lb.project1:
		resource "azurerm_lb" "project1" {
			id                   = "/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Network/loadBalancers/nanod-lb"
			location             = "eastus"
			name                 = "nanod-lb"
			private_ip_addresses = []
			resource_group_name  = "nanod-rg"
			sku                  = "Basic"
			tags                 = {
				"ND" = "1"
			}

			frontend_ip_configuration {
				id                            = "/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Network/loadBalancers/nanod-lb/frontendIPConfigurations/nanod-LbPublicIPAddress"
				inbound_nat_rules             = []
				load_balancer_rules           = []
				name                          = "nanod-LbPublicIPAddress"
				outbound_rules                = []
				private_ip_address_allocation = "Dynamic"
				public_ip_address_id          = "/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Network/publicIPAddresses/nanod-pub-nic"
				zones                         = []
			}
		}

		# azurerm_lb_backend_address_pool.project1:
		resource "azurerm_lb_backend_address_pool" "project1" {
			backend_ip_configurations = []
			id                        = "/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Network/loadBalancers/nanod-lb/backendAddressPools/nanod-BackEndAddressPool"
			load_balancing_rules      = []
			loadbalancer_id           = "/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Network/loadBalancers/nanod-lb"
			name                      = "nanod-BackEndAddressPool"
			outbound_rules            = []
			resource_group_name       = "nanod-rg"
		}

		# azurerm_linux_virtual_machine.project1[0]:
		resource "azurerm_linux_virtual_machine" "project1" {
			admin_password                  = (sensitive value)
			admin_username                  = "adminuser"
			allow_extension_operations      = true
			availability_set_id             = "/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Compute/availabilitySets/NANOD-AVSET"
			computer_name                   = "nanod0-vm"
			disable_password_authentication = false
			encryption_at_host_enabled      = false
			extensions_time_budget          = "PT1H30M"
			id                              = "/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Compute/virtualMachines/nanod0-vm"
			location                        = "eastus"
			max_bid_price                   = -1
			name                            = "nanod0-vm"
			network_interface_ids           = [
				"/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Network/networkInterfaces/nanod0-nic",
			]
			platform_fault_domain           = -1
			priority                        = "Regular"
			private_ip_address              = "10.0.2.5"
			private_ip_addresses            = [
				"10.0.2.5",
			]
			provision_vm_agent              = true
			public_ip_addresses             = []
			resource_group_name             = "nanod-rg"
			size                            = "Standard_D2s_v3"
			source_image_id                 = "/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Compute/images/myPackerImage"
			tags                            = {
				"ND" = "1"
			}
			virtual_machine_id              = "ae377ef9-e309-483b-a3bd-c6b7b4ba9890"

			os_disk {
				caching                   = "ReadWrite"
				disk_size_gb              = 30
				name                      = "nanod0-OSdisk"
				storage_account_type      = "Standard_LRS"
				write_accelerator_enabled = false
			}
		}

		# azurerm_linux_virtual_machine.project1[1]:
		resource "azurerm_linux_virtual_machine" "project1" {
			admin_password                  = (sensitive value)
			admin_username                  = "adminuser"
			allow_extension_operations      = true
			availability_set_id             = "/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Compute/availabilitySets/NANOD-AVSET"
			computer_name                   = "nanod1-vm"
			disable_password_authentication = false
			encryption_at_host_enabled      = false
			extensions_time_budget          = "PT1H30M"
			id                              = "/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Compute/virtualMachines/nanod1-vm"
			location                        = "eastus"
			max_bid_price                   = -1
			name                            = "nanod1-vm"
			network_interface_ids           = [
				"/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Network/networkInterfaces/nanod1-nic",
			]
			platform_fault_domain           = -1
			priority                        = "Regular"
			private_ip_address              = "10.0.2.4"
			private_ip_addresses            = [
				"10.0.2.4",
			]
			provision_vm_agent              = true
			public_ip_addresses             = []
			resource_group_name             = "nanod-rg"
			size                            = "Standard_D2s_v3"
			source_image_id                 = "/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Compute/images/myPackerImage"
			tags                            = {
				"ND" = "1"
			}
			virtual_machine_id              = "7e7c1368-666e-4ee4-ac3c-30ed15eb9874"

			os_disk {
				caching                   = "ReadWrite"
				disk_size_gb              = 30
				name                      = "nanod1-OSdisk"
				storage_account_type      = "Standard_LRS"
				write_accelerator_enabled = false
			}
		}

		# azurerm_linux_virtual_machine.project1[2]:
		resource "azurerm_linux_virtual_machine" "project1" {
			admin_password                  = (sensitive value)
			admin_username                  = "adminuser"
			allow_extension_operations      = true
			availability_set_id             = "/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Compute/availabilitySets/NANOD-AVSET"
			computer_name                   = "nanod2-vm"
			disable_password_authentication = false
			encryption_at_host_enabled      = false
			extensions_time_budget          = "PT1H30M"
			id                              = "/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Compute/virtualMachines/nanod2-vm"
			location                        = "eastus"
			max_bid_price                   = -1
			name                            = "nanod2-vm"
			network_interface_ids           = [
				"/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Network/networkInterfaces/nanod2-nic",
			]
			platform_fault_domain           = -1
			priority                        = "Regular"
			private_ip_address              = "10.0.2.6"
			private_ip_addresses            = [
				"10.0.2.6",
			]
			provision_vm_agent              = true
			public_ip_addresses             = []
			resource_group_name             = "nanod-rg"
			size                            = "Standard_D2s_v3"
			source_image_id                 = "/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Compute/images/myPackerImage"
			tags                            = {
				"ND" = "1"
			}
			virtual_machine_id              = "7d3ef309-d474-4eed-afef-4903d17cc7e4"

			os_disk {
				caching                   = "ReadWrite"
				disk_size_gb              = 30
				name                      = "nanod2-OSdisk"
				storage_account_type      = "Standard_LRS"
				write_accelerator_enabled = false
			}
		}

		# azurerm_managed_disk.project1[0]:
		resource "azurerm_managed_disk" "project1" {
			create_option        = "Empty"
			disk_iops_read_write = 500
			disk_mbps_read_write = 60
			disk_size_gb         = 1
			id                   = "/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Compute/disks/nanod0-mDisk"
			location             = "eastus"
			name                 = "nanod0-mDisk"
			resource_group_name  = "nanod-rg"
			storage_account_type = "Standard_LRS"
			tags                 = {
				"ND" = "1"
			}
			zones                = []
		}

		# azurerm_managed_disk.project1[1]:
		resource "azurerm_managed_disk" "project1" {
			create_option        = "Empty"
			disk_iops_read_write = 500
			disk_mbps_read_write = 60
			disk_size_gb         = 1
			id                   = "/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Compute/disks/nanod1-mDisk"
			location             = "eastus"
			name                 = "nanod1-mDisk"
			resource_group_name  = "nanod-rg"
			storage_account_type = "Standard_LRS"
			tags                 = {
				"ND" = "1"
			}
			zones                = []
		}

		# azurerm_managed_disk.project1[2]:
		resource "azurerm_managed_disk" "project1" {
			create_option        = "Empty"
			disk_iops_read_write = 500
			disk_mbps_read_write = 60
			disk_size_gb         = 1
			id                   = "/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Compute/disks/nanod2-mDisk"
			location             = "eastus"
			name                 = "nanod2-mDisk"
			resource_group_name  = "nanod-rg"
			storage_account_type = "Standard_LRS"
			tags                 = {
				"ND" = "1"
			}
			zones                = []
		}

		# azurerm_network_interface.project1[0]:
		resource "azurerm_network_interface" "project1" {
			applied_dns_servers           = []
			dns_servers                   = []
			enable_accelerated_networking = false
			enable_ip_forwarding          = false
			id                            = "/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Network/networkInterfaces/nanod0-nic"
			internal_domain_name_suffix   = "qpkmhuzjcttefie3is1ylrpnjg.bx.internal.cloudapp.net"
			location                      = "eastus"
			mac_address                   = "00-0D-3A-9E-84-62"
			name                          = "nanod0-nic"
			private_ip_address            = "10.0.2.5"
			private_ip_addresses          = [
				"10.0.2.5",
			]
			resource_group_name           = "nanod-rg"
			tags                          = {
				"ND" = "1"
			}
			virtual_machine_id            = "/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Compute/virtualMachines/nanod0-vm"

			ip_configuration {
				name                          = "internal"
				primary                       = true
				private_ip_address            = "10.0.2.5"
				private_ip_address_allocation = "Dynamic"
				private_ip_address_version    = "IPv4"
				subnet_id                     = "/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Network/virtualNetworks/nanod-network/subnets/nanod-subnet"
			}
		}

		# azurerm_network_interface.project1[1]:
		resource "azurerm_network_interface" "project1" {
			applied_dns_servers           = []
			dns_servers                   = []
			enable_accelerated_networking = false
			enable_ip_forwarding          = false
			id                            = "/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Network/networkInterfaces/nanod1-nic"
			internal_domain_name_suffix   = "qpkmhuzjcttefie3is1ylrpnjg.bx.internal.cloudapp.net"
			location                      = "eastus"
			mac_address                   = "00-0D-3A-9E-82-2B"
			name                          = "nanod1-nic"
			private_ip_address            = "10.0.2.4"
			private_ip_addresses          = [
				"10.0.2.4",
			]
			resource_group_name           = "nanod-rg"
			tags                          = {
				"ND" = "1"
			}
			virtual_machine_id            = "/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Compute/virtualMachines/nanod1-vm"

			ip_configuration {
				name                          = "internal"
				primary                       = true
				private_ip_address            = "10.0.2.4"
				private_ip_address_allocation = "Dynamic"
				private_ip_address_version    = "IPv4"
				subnet_id                     = "/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Network/virtualNetworks/nanod-network/subnets/nanod-subnet"
			}
		}

		# azurerm_network_interface.project1[2]:
		resource "azurerm_network_interface" "project1" {
			applied_dns_servers           = []
			dns_servers                   = []
			enable_accelerated_networking = false
			enable_ip_forwarding          = false
			id                            = "/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Network/networkInterfaces/nanod2-nic"
			internal_domain_name_suffix   = "qpkmhuzjcttefie3is1ylrpnjg.bx.internal.cloudapp.net"
			location                      = "eastus"
			mac_address                   = "00-0D-3A-9E-87-20"
			name                          = "nanod2-nic"
			private_ip_address            = "10.0.2.6"
			private_ip_addresses          = [
				"10.0.2.6",
			]
			resource_group_name           = "nanod-rg"
			tags                          = {
				"ND" = "1"
			}
			virtual_machine_id            = "/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Compute/virtualMachines/nanod2-vm"

			ip_configuration {
				name                          = "internal"
				primary                       = true
				private_ip_address            = "10.0.2.6"
				private_ip_address_allocation = "Dynamic"
				private_ip_address_version    = "IPv4"
				subnet_id                     = "/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Network/virtualNetworks/nanod-network/subnets/nanod-subnet"
			}
		}

		# azurerm_network_interface_backend_address_pool_association.project1[2]:
		resource "azurerm_network_interface_backend_address_pool_association" "project1" {
			backend_address_pool_id = "/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Network/loadBalancers/nanod-lb/backendAddressPools/nanod-BackEndAddressPool"
			id                      = "/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Network/networkInterfaces/nanod2-nic/ipConfigurations/internal|/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Network/loadBalancers/nanod-lb/backendAddressPools/nanod-BackEndAddressPool"
			ip_configuration_name   = "internal"
			network_interface_id    = "/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Network/networkInterfaces/nanod2-nic"
		}

		# azurerm_network_interface_backend_address_pool_association.project1[0]:
		resource "azurerm_network_interface_backend_address_pool_association" "project1" {
			backend_address_pool_id = "/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Network/loadBalancers/nanod-lb/backendAddressPools/nanod-BackEndAddressPool"
			id                      = "/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Network/networkInterfaces/nanod0-nic/ipConfigurations/internal|/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Network/loadBalancers/nanod-lb/backendAddressPools/nanod-BackEndAddressPool"
			ip_configuration_name   = "internal"
			network_interface_id    = "/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Network/networkInterfaces/nanod0-nic"
		}

		# azurerm_network_interface_backend_address_pool_association.project1[1]:
		resource "azurerm_network_interface_backend_address_pool_association" "project1" {
			backend_address_pool_id = "/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Network/loadBalancers/nanod-lb/backendAddressPools/nanod-BackEndAddressPool"
			id                      = "/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Network/networkInterfaces/nanod1-nic/ipConfigurations/internal|/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Network/loadBalancers/nanod-lb/backendAddressPools/nanod-BackEndAddressPool"
			ip_configuration_name   = "internal"
			network_interface_id    = "/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Network/networkInterfaces/nanod1-nic"
		}

		# azurerm_network_security_group.project1:
		resource "azurerm_network_security_group" "project1" {
			id                  = "/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Network/networkSecurityGroups/nanod-netSecGrp"
			location            = "eastus"
			name                = "nanod-netSecGrp"
			resource_group_name = "nanod-rg"
			security_rule       = [
				{
					access                                     = "Allow"
					description                                = ""
					destination_address_prefix                 = "*"
					destination_address_prefixes               = []
					destination_application_security_group_ids = []
					destination_port_range                     = "*"
					destination_port_ranges                    = []
					direction                                  = "Inbound"
					name                                       = "inboundAccess"
					priority                                   = 100
					protocol                                   = "Tcp"
					source_address_prefix                      = "10.0.0.0/24"
					source_address_prefixes                    = []
					source_application_security_group_ids      = []
					source_port_range                          = "*"
					source_port_ranges                         = []
				},
			]
			tags                = {
				"ND" = "1"
			}
		}

		# azurerm_public_ip.project1:
		resource "azurerm_public_ip" "project1" {
			allocation_method       = "Dynamic"
			id                      = "/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Network/publicIPAddresses/nanod-pub-nic"
			idle_timeout_in_minutes = 4
			ip_tags                 = {}
			ip_version              = "IPv4"
			location                = "eastus"
			name                    = "nanod-pub-nic"
			resource_group_name     = "nanod-rg"
			sku                     = "Basic"
			tags                    = {
				"ND" = "1"
			}
			zones                   = []
		}

		# azurerm_resource_group.project1:
		resource "azurerm_resource_group" "project1" {
			id       = "/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg"
			location = "eastus"
			name     = "nanod-rg"
			tags     = {
				"ND" = "1"
			}
		}

		# azurerm_subnet.project1:
		resource "azurerm_subnet" "project1" {
			address_prefix                                 = "10.0.2.0/24"
			address_prefixes                               = [
				"10.0.2.0/24",
			]
			enforce_private_link_endpoint_network_policies = false
			enforce_private_link_service_network_policies  = false
			id                                             = "/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Network/virtualNetworks/nanod-network/subnets/nanod-subnet"
			name                                           = "nanod-subnet"
			resource_group_name                            = "nanod-rg"
			service_endpoint_policy_ids                    = []
			service_endpoints                              = []
			virtual_network_name                           = "nanod-network"
		}

		# azurerm_virtual_network.project1:
		resource "azurerm_virtual_network" "project1" {
			address_space         = [
				"10.0.0.0/22",
			]
			dns_servers           = []
			guid                  = "d3c3d483-1429-42e6-a09d-44b785c5ed4e"
			id                    = "/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Network/virtualNetworks/nanod-network"
			location              = "eastus"
			name                  = "nanod-network"
			resource_group_name   = "nanod-rg"
			subnet                = [
				{
					address_prefix = "10.0.2.0/24"
					id             = "/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Network/virtualNetworks/nanod-network/subnets/nanod-subnet"
					name           = "nanod-subnet"
					security_group = ""
				},
			]
			tags                  = {
				"ND" = "1"
			}
			vm_protection_enabled = false
		}

		# data.azurerm_image.PackerImage:
		data "azurerm_image" "PackerImage" {
			data_disk           = []
			id                  = "/subscriptions/<your-subscription-id>/resourceGroups/nanod-rg/providers/Microsoft.Compute/images/myPackerImage"
			location            = "eastus"
			name                = "myPackerImage"
			os_disk             = [
				{
					blob_uri        = ""
					caching         = "ReadWrite"
					managed_disk_id = "/subscriptions/<your-subscription-id>/resourceGroups/pkr-Resource-Group-wgx5sqp3z1/providers/Microsoft.Compute/disks/pkroswgx5sqp3z1"
					os_state        = "Generalized"
					os_type         = "Linux"
					size_gb         = 30
				},
			]
			resource_group_name = "nanod-rg"
			sort_descending     = false
			tags                = {
				"ND" = "1"
			}
			zone_resilient      = false
		}
