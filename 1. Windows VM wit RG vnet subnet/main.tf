# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
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



# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "RG1"
  location = "east us"
}
#VNET with subnet:

resource "azurerm_virtual_network" "VNET" {
  name                = "VNET1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]


}
/*
#subnet:

variable "name1" {
  type = list(object({
    name=string
    address_prefixes = string
  }))
  default = [{name:"sub1", address_prefixes:"10.0.5.0/24"},{name:"sub2", address_prefixes:"10.0.3.0/24"},{name:"sub3", address_prefixes:"10.0.4.0/24"}]
}

resource "azurerm_subnet" "subnet" { 
  count=3
  name                 = element("${var.name1}","${count.index}").name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.VNET.name
  address_prefixes     = [element("${var.name1}","${count.index}").address_prefixes]
}
resource "azurerm_subnet" "subnet1" {
  name                 = "internal3"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.VNET.name
  address_prefixes     = ["10.0.2.0/24"]

}
*/

resource "azurerm_network_interface" "nic1" {
  name                = "NIC1"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name

  ip_configuration {
    name                          = "internal1"
   // subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
  }
}




resource "azurerm_windows_virtual_machine" "VM" {
  name                = "VM1"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
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




