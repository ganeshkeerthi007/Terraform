terraform {
  required_providers{
    azurerm = {
        source = "hashicorp/azurerm"
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
    name = "${var.prefix}-RG"
    location = "${var.location}"  
}

resource "azurerm_virtual_network" "vent1" {
    name = "${var.prefix}-Vnet"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    address_space = ["${var.vnet_cidr_prefix}"]
}
resource "azurerm_subnet" "subnet1" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vent1.name
  address_prefixes     = ["10.0.1.0/24"]
}