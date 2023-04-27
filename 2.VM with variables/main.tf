terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

subscription_id  	="a2f1e4b8-37f7-4f23-948a-bc9c516e39c4"
client_id 		    ="76f7cf1a-e296-41aa-96f0-dbd497d9a41c"
client_secret 	  ="oth8Q~AWrb-ffJhWtlm4Jyux13RGxkXB5UA4Bb.g"
tenant_id 		    ="6bb63002-f9de-4939-b157-62b9ca47a3d7"

}

resource "azurerm_resource_group" "rg1" {
  name     = "${var.rgname}"
  location = "${var.rglocation}"
}


resource "azurerm_network_security_group" "nsg1" {
  name                = "${var.nsg}"
  location            = "${azurerm_resource_group.rg1.location}"
  resource_group_name = "${azurerm_resource_group.rg1.name}"
}



resource "azurerm_virtual_network" "vnet1" {
  name                = "${var.vnet}"
  location            =  "${azurerm_resource_group.rg1.location}"
  resource_group_name =  "${azurerm_resource_group.rg1.name}"
  address_space       = ["${var.address}"]
  dns_servers         = "${var.dns_servers}"


}


resource "azurerm_subnet" "subnet1" {
  name                 = "${var.subnet}"
  resource_group_name  = "${azurerm_resource_group.rg1.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet1.name}"
  address_prefixes     = ["${var.address_prefixes}"]
}


resource "azurerm_network_interface" "nic1" {
  name                = "${var.nic}"
  location            = "${azurerm_resource_group.rg1.location}"
  resource_group_name = "${azurerm_resource_group.rg1.name}"

  ip_configuration {
    name                          = "${var.ip_configuration}"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
  }
}




resource "azurerm_windows_virtual_machine" "vm1" {
  name                = "${var.vm}"
  resource_group_name = "${azurerm_resource_group.rg1.name}"
  location            = "${azurerm_resource_group.rg1.location}"
  size                = "${var.size}"
  admin_username      = "${var.admin_username}"
  admin_password      = "${var.admin_password}"
  network_interface_ids = [
    azurerm_network_interface.nic1.id,
  ]

#admin_ssh_key {
  ##  username   = "adminuser"
   # public_key = file("~/.ssh/id_rsa.pub")
 ## }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_storage_account" "ST1" {
  name                = "mybob112211"
  resource_group_name = azurerm_resource_group.rg1.name

  location                 = azurerm_resource_group.rg1.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_rules {
    default_action             = "Allow"
    #ip_rules                   = ["100.0.0.1"]
    virtual_network_subnet_ids = [azurerm_subnet.subnet1.id]
  }

  
}