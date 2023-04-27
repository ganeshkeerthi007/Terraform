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
/*
variable "name1" {
  type = list(object({
    name=string
    address_prefixes = string
  }))
  default = [{name:"sub1", address_prefixes:"10.0.5.0/24"},{name:"sub2", address_prefixes:"10.0.3.0/24"},{name:"sub3", address_prefixes:"10.0.4.0/24"}]
} */

variable "name1" {
  type = list(object({
    rgname = string
    rglocation = string
    vnet = string
    nsg = string
    subnet = string
    vm = string
    admin_username = string
    admin_password = string
    address_prefixes =  string
  }))
  default = [{rgname:"rg11",rglocation:"east us",vnet:"vnet11", nsg:"nsg11", subnet:"sub1", address_prefixes:"10.0.5.0/24",vm:"vm11",admin_username:"user11",admin_password:"P@$$w0rd1234!"},
             {rgname:"rg12",rglocation:"east us",vnet:"vnet12", nsg:"nsg12", subnet:"sub1",address_prefixes:"10.0.6.0/24",vm:"vm12",admin_username:"user12",admin_password:"P@$$w0rd1234!"},
             {rgname:"rg13",rglocation:"east us",vnet:"vnet13", nsg:"nsg13", subnet:"sub1", address_prefixes:"10.0.7.0/24",vm:"vm13",admin_username:"user13",admin_password:"P@$$w0rd1234!"},
             {rgname:"rg14",rglocation:"uk south",vnet:"vnet14",nsg:"nsg14", subnet:"sub1", address_prefixes:"10.0.8.0/24",vm:"vm14",admin_username:"user14",admin_password:"P@$$w0rd1234!"},
             {rgname:"rg15",rglocation:"uk south",vnet:"vnet15",nsg:null, subnet:null, address_prefixes:"10.0.5.0/24",vm:"vm15",admin_username:"user15",admin_password:"P@$$w0rd1234!"}
             ]
             }


resource "azurerm_resource_group" "rg" {
  count=length(var.name1)


  name     = element("${var.name1}","${count.index}").rgname
  location = element("${var.name1}","${count.index}").rglocation

}
#VNET with subnet:

resource "azurerm_virtual_network" "VNET" {
  count=length(var.name1)
  name                = element("${var.name1}","${count.index}").vnet
  location            = element("${var.name1}","${count.index}").rglocation
  resource_group_name = element("${var.name1}","${count.index}").rgname
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]
depends_on = [
    azurerm_resource_group.rg
  ]
  
}

#subnet:
resource "azurerm_subnet" "subnet" { 
  count=length(var.name1)-1
 
  name                 = "subnet11"
  resource_group_name  = element("${var.name1}","${count.index}").rgname
  virtual_network_name = element("${var.name1}","${count.index}").vnet
  address_prefixes     = [element("${var.name1}","${count.index}").address_prefixes]

  depends_on = [
    azurerm_virtual_network.VNET
  ]
}

resource "azurerm_network_security_group" "nsg" {


  count=length(var.name1)-1
 
  name                = element("${var.name1}","${count.index}").nsg
  location            = element("${var.name1}","${count.index}").rglocation
  resource_group_name = element("${var.name1}","${count.index}").rgname

  depends_on = [
    azurerm_resource_group.rg
  ]
}
#NIC:

resource "azurerm_network_interface" "nic" {
  count=length(var.name1)-1

  name                = "nic11"
  location            = element("${var.name1}","${count.index}").rglocation
  resource_group_name = element("${var.name1}","${count.index}").rgname

  ip_configuration {
    name                          = "internal"
    subnet_id                     =  azurerm_subnet.subnet[count.index].id
    private_ip_address_allocation = "Dynamic"
  }
    depends_on = [
    azurerm_virtual_network.VNET
  ]
  
}

#VM for windows:

resource "azurerm_windows_virtual_machine" "vm" {
  count=length(var.name1)-3

  name                = element("${var.name1}","${count.index}").vm
  resource_group_name = element("${var.name1}","${count.index}").rgname
  location            = element("${var.name1}","${count.index}").rglocation
  size                = "Standard_F2"
  admin_username      = element("${var.name1}","${count.index}").admin_username
  admin_password      = element("${var.name1}","${count.index}").admin_password
  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id,
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
  depends_on = [
    azurerm_virtual_network.VNET
  ]
}


