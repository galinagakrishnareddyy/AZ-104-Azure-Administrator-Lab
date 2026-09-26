variable "subscription_id" {
  description = "Azure subscription ID."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
  default     = "centralindia"
}

variable "resource_group_name" {
  type    = string
  default = "RG-AzureNetworking-Lab"
}

variable "vnet_name" {
  type    = string
  default = "VNet-Lab"
}

variable "vnet_address_space" {
  type    = string
  default = "10.10.0.0/16"
}

variable "web_subnet_name" {
  type    = string
  default = "WebSubnet"
}

variable "web_subnet_prefix" {
  type    = string
  default = "10.10.1.0/24"
}

variable "db_subnet_name" {
  type    = string
  default = "DBSubnet"
}

variable "db_subnet_prefix" {
  type    = string
  default = "10.10.2.0/24"
}

variable "admin_username" {
  type    = string
  default = "azureuser"
}

variable "ssh_public_key" {
  description = "Contents of the SSH public key."
  type        = string
  sensitive   = true
}

variable "allowed_ssh_source" {
  description = "CIDR allowed to SSH. Use your public IP/32 instead of * for better security."
  type        = string
  default     = "*"
}

variable "vm_size" {
  type    = string
  default = "Standard_B1s"
}

variable "private_dns_zone_name" {
  type    = string
  default = "internal.example"
}

variable "enable_public_dns" {
  type    = bool
  default = false
}

variable "public_dns_zone" {
  type    = string
  default = ""
}

variable "tags" {
  type = map(string)
  default = {
    Project = "AZ-104-Azure-Networking-Lab"
    Course  = "AZ-104"
  }
}
