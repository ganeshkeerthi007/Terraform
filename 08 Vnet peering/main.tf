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
  
  name     = "RG-1"
  location = "east us"
  
}

resource "azurerm_virtual_network" "VNET" {
  count = 5
  name                = "VNET-${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.1.0/24"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]


}
resource "azurerm_virtual_network_peering" "peering" {    
    
  count = 1
  name                      = "peer1to2"
  resource_group_name       = azurerm_resource_group.rg[count.index].name
  virtual_network_name      = azurerm_virtual_network.VNET[count.index].name
  remote_virtual_network_id = azurerm_virtual_network.VNET[count.index+1].id
}

resource "azurerm_virtual_network_peering" "peering1" {
  count = 1
  name                      = "peer2to1"
  resource_group_name       = azurerm_resource_group.rg[count.index+1].name
  virtual_network_name      = azurerm_virtual_network.VNET[count.index+1].name
  remote_virtual_network_id = azurerm_virtual_network.VNET[count.index].id
}
