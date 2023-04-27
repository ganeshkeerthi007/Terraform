module "module_test" {
source =  "./Modules" 
prefix = "test"
location = "EastUs"
vnet_cidr_prefix = "10.0.0.0/16"
}