terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}

subscription_id  	="f3ce8f3b-d87a-4dc5-ae70-ea8c4785082b"
client_id 		    ="bb474357-693f-4c24-97cf-ba188ec3267b"
client_secret 	    ="aOA8Q~sjPcAlA9cmMSDG2MgkOvAT-bSD7ea.Nak7"
tenant_id 		    ="6bb63002-f9de-4939-b157-62b9ca47a3d7"

}
resource "azurerm_resource_group" "rg" {
  name     = "RG1"
  location = "east us"
  
}

resource "azurerm_virtual_network" "VNET" {
  name                = "VNET1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]


}

resource "azurerm_subnet" "subnet" { 
  #count=2
  name                 = "subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.VNET.name
  address_prefixes     = ["10.0.2.0/24"]
}


resource "azurerm_network_interface" "nic1" {
  name                = "NIC1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {  
    name                          = "internal1"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.2.12"
    #count=2
  }
}




resource "azurerm_windows_virtual_machine" "VM" {
  
  name                = "VM1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.nic1.id,
  ]


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
  #count = 2
}
 /*
#resource "azurerm_virtual_network_peering" "example-1" {
 name                      = "peer1to2"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.VNET.name
  remote_virtual_network_id = "7f99d5a6-24aa-4f90-ad97-425fc381fdd9"
}

resource "azurerm_virtual_network_peering" "example-2" {
  name                      = "peer2to1"
  resource_group_name       = azurerm_resource_group.rg.RG2
  virtual_network_name      = azurerm_virtual_network.VNET.VNET2
  remote_virtual_network_id = "e164bdac-2011-435a-993e-69df3fa9014b"
}
*/