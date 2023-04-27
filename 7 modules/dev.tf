
module "module_dev" {
source =  "./Modules" 
prefix = "dev"
location = "EastUs"
vnet_cidr_prefix = "10.0.0.0/16"
}