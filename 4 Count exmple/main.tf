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
variable "prefix" {
  default= "RG"
}
variable "prefix1" {
  default = "vnet"
}

resource "azurerm_resource_group" "RG1" {
    count = 3
  #  prefix="rg"
  name = "${var.prefix}-${count.index}"
  location = "east us"
}

resource "azurerm_virtual_network" "VNET" {

  count=3
  name                = "${var.prefix1}-${count.index}"
  location            = "${azurerm_resource_group.RG1[count.index].location}" 
  resource_group_name = "${azurerm_resource_group.RG1[count.index].name}"
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]
depends_on = [
    azurerm_resource_group.RG1
  ]

}
#azurerm_resource_group.RG1[count.index]