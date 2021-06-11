# description
#
# variables.tf: This file holds the values of the variables used in the template.
# output.tf: This file describes the settings that display after deployment.
# main.tf: This file contains the code of the infrastructure that we are deploying.
#
# created by Rajeev 6/8/2021
#

# basic setup
provider "azurerm" {
  features {}
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

# step-1: create a resource group
resource "azurerm_resource_group" "project1" {
  name     = "${var.prefix}-rg"
  location = "${var.location}"
  tags = {
    ND = "1"
  }
}

# step-2: create virtual network
resource "azurerm_virtual_network" "project1" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/22"]
  location            = azurerm_resource_group.project1.location
  resource_group_name = azurerm_resource_group.project1.name
  tags = {
    ND = "1"
  }
}

# step-2: create virtual subnet
resource "azurerm_subnet" "project1" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = azurerm_resource_group.project1.name
  virtual_network_name = azurerm_virtual_network.project1.name
  address_prefixes     = ["10.0.2.0/24"]
}

# step-3: create network security group
resource "azurerm_network_security_group" "project1" {
  name                = "${var.prefix}-netSecGrp"
  location            = azurerm_resource_group.project1.location
  resource_group_name = azurerm_resource_group.project1.name
  security_group_name = "${var.prefix}-nsg"
  source_address_prefix = ["10.0.0.0/22"]

  security_rule {
    name                       = "inboundAccess"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.0.0.0/22"
    destination_address_prefix = "10.0.0.0/22"
  }
  predefined_rules = [
    {
      name     = "SSH"
      priority = "500"
    }
  ]
  custom_rules = [
    {
      name                   = "sshRule"
      priority               = 201
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "tcp"
      source_port_range      = "*"
      destination_port_range = "22"
      source_address_prefix  = "10.0.0.0/22"
      description            = "ssh-for-our-subnet-only"
    }
  ]
  tags = {
    ND = "1"
  }
}

# step 4: defining pulic IP
resource "azurerm_public_ip" "project1" {
  name                = "${var.prefix}-pub-nic"
  location            = azurerm_resource_group.project1.location
  resource_group_name = azurerm_resource_group.project1.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
  tags = {
    ND = "1"
  }
}

# step 5: defining Net Intfc.
resource "azurerm_network_interface" "project1" {
  name                = "${var.prefix}-nic"
  resource_group_name = azurerm_resource_group.project1.name
  location            = azurerm_resource_group.project1.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}


# step 6: create load balancer
resource "azurerm_lb" "project1" {
  name                = "${var.prefix}-lb"
  resource_group_name = azurerm_resource_group.project1.name
  location            = azurerm_resource_group.project1.location

  frontend_ip_configuration {
    name                 = "${var.prefix}-LbPublicIPAddress"
    public_ip_address_id = azurerm_public_ip.project1.id
  }

  tags = {
    ND = "1"
  }
}

# step 6: part 2
resource "azurerm_lb_backend_address_pool" "project1" {
  resource_group_name = azurerm_resource_group.project1.name
  loadbalancer_id = azurerm_lb.project1.id
  name            = "${var.prefix}-BackEndAddressPool"
}

# step 6: part 3
resource "azurerm_network_interface_backend_address_pool_association" "project1" {
  network_interface_id    = azurerm_network_interface.project1.id
  ip_configuration_name   = "${var.prefix}-nic-lb-pool-cfg"
  backend_address_pool_id = azurerm_lb_backend_address_pool.project1.id
}

# step 7: create virtual machine availability set
resource "azurerm_availability_set" "project1" {
  name                = "${var.prefix}-avset"
  location            = azurerm_resource_group.project1.location
  resource_group_name = azurerm_resource_group.project1.name

  tags = {
    ND = "1"
  }
}

# step 8: build packer image using server.json

# step 9: create VMs using packer image. 1 VM
#
# sub-step-1: create a reference to the Packer image:
data "azurerm_image" "packer-image" {
  name                = "myPackerImage"
  resource_group_name = azurerm_resource_group.project1.name
}
#
# sub-step-2: build VM based on above ref.
resource "azurerm_linux_virtual_machine" "project1" {
  name                            = "${var.prefix}-vm"
  resource_group_name             = azurerm_resource_group.project1.name
  location                        = azurerm_resource_group.project1.location
  size                            = "Standard_D2s_v3"
  admin_username                  = var.username      #value at runtime
  admin_password                  = var.password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.project1.id,
  ]

  source_image_id = data.azurerm_image.packer-image.id

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  tags = {
    ND = "1"
  }
}
