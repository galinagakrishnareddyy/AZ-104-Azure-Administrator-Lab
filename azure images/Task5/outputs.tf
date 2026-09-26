output "resource_group_name" {
  value = azurerm_resource_group.lab.name
}

output "vm_name" {
  value = azurerm_linux_virtual_machine.vm.name
}

output "vm_private_ip" {
  value = azurerm_network_interface.vm.private_ip_address
}

output "vm_public_ip" {
  value = azurerm_public_ip.vm.ip_address
}

output "storage_account_name" {
  value = azurerm_storage_account.lab.name
}

output "storage_account_id" {
  value = azurerm_storage_account.lab.id
}

output "blob_container_name" {
  value = azurerm_storage_container.blob.name
}

output "file_share_name" {
  value = azurerm_storage_share.files.name
}

output "blob_endpoint" {
  value = azurerm_storage_account.lab.primary_blob_endpoint
}

output "file_endpoint" {
  value = azurerm_storage_account.lab.primary_file_endpoint
}

output "ssh_command" {
  value = "ssh ${var.admin_username}@${azurerm_public_ip.vm.ip_address}"
}
