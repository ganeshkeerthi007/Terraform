variable "rgname" {
  type = string
  description = "resource group name"
}

variable "rglocation" {
  type = string
  description = "resource group location"
}

variable "nsg" {
  type = string
  description = "resource nsg name"
}

variable "vnet" {
  type = string
  description = "resource vnet name"
}

variable "address" {
  type = string
  description = "resource address name"
}

variable "dns_servers" {
  type = list
  description = "resource dns_server name"
}

variable "subnet" {
  type = string
  description = "resource subnet"
}

variable "address_prefixes" {
  type = string
  description = "resource address_prefixes"
}

variable "nic" {
  type = string
  description = "resource nic"
}

variable "ip_configuration" {
  type = string
  description = "resource ip_config"
}

variable "vm" {
  type = string
  description = "resource vm name"
}

variable "size" {
  type = string
  description = "resource size "
}

variable "admin_username" {
  type = string
  description = "resource admin username "
}

variable "admin_password" {
  type = string
  description = "resource admin password "
}