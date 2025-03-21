terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_virtual_network" "vnet" {
  count               = var.subnet_id == "" ? 1 : 0
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = "dev"
  }
}

resource "azurerm_subnet" "subnet" {
  count                = var.subnet_id == "" ? 1 : 0
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet[0].name
  address_prefixes     = ["10.0.1.0/24"]
}

locals {
  subnet_id = var.subnet_id != "" ? var.subnet_id : azurerm_subnet.subnet[0].id
}

resource "azurerm_network_interface" "nic" {
  count               = var.vm_count
  name                = "nic-atn-dev-sea-${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = local.subnet_id 
    private_ip_address_allocation = "Static"
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  count                 = var.vm_count
  name                  = "vm-atn-dev-${count.index + 1}"
  location              = var.location
  resource_group_name   = var.resource_group_name
  size                  = "Standard_B2s"
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter-smalldisk"
    version   = "latest"
  }
}
