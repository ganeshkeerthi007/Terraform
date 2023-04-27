terraform {
  
  required_providers {
    azurerm ={
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


resource "azurerm_resource_group" "example" {
  name = "storage_RG"
  location = "EastUS"
}

resource "azurerm_storage_account" "storage" {
  name = "storagetfaccountnew"
  account_replication_type = "LRS"
  account_tier = "Standard"
  resource_group_name = azurerm_resource_group.example.name
  location = azurerm_resource_group.example.location

}

//terraform import azurerm_resource_group.example /subscriptions/f3ce8f3b-d87a-4dc5-ae70-ea8c4785082b/resourceGroups/storage_RG
//terraform import azurerm_storage_account."storage" /subscriptions/f3ce8f3b-d87a-4dc5-ae70-ea8c4785082b/resourceGroups/storage_RG/providers/Microsoft.Storage/storageAccounts/storagetfaccountnew
//terraform import azurerm_resource_group.example /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example
//terraform import azurerm_resource_group.example /subscriptions/f3ce8f3b-d87a-4dc5-ae70-ea8c4785082b/resourceGroups/storage_RG

