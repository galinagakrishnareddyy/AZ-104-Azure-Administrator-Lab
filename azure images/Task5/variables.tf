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
  default = "RG-AZ104-Storage-Lab"
}

variable "storage_account_name" {
  description = "Globally unique lowercase storage account name, 3-24 characters."
  type        = string
}

variable "container_name" {
  type    = string
  default = "labcontainer"
}

variable "file_share_name" {
  type    = string
  default = "labshare"
}

variable "file_share_quota_gb" {
  type    = number
  default = 5
}

variable "admin_username" {
  type    = string
  default = "azureuser"
}

variable "ssh_public_key" {
  description = "Contents of your SSH public key."
  type        = string
  sensitive   = true
}

variable "allowed_ssh_source" {
  description = "CIDR allowed to connect to SSH. Use your public IP/32."
  type        = string
  default     = "*"
}

variable "vm_size" {
  type    = string
  default = "Standard_B1s"
}

variable "tags" {
  type = map(string)

  default = {
    Project = "AZ-104-Session-5"
    Course  = "Azure Administrator"
  }
}
