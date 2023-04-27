terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

module "module_prod" {
source =  "./Modules" 
prefix = "prod"
location = "EastUs"
vnet_cidr_prefix = "10.0.0.0/16"
}