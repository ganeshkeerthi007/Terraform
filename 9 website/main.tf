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
  name     = "websiteRG"
  location = "UK South"
}

resource "azurerm_service_plan" "WEB1" {
  name                = "mysocialmedia1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "P1v2"

  
}

resource "azurerm_app_service" "website" {
  name                = "mysocialmedia1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_service_plan.WEB1.id

  site_config {
    php_version = "7.4"
    
  }

 


}