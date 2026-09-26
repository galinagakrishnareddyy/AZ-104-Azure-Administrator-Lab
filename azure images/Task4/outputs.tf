output "resource_group_name" {
  value = azurerm_resource_group.lab.name
}

output "vnet_id" {
  value = azurerm_virtual_network.lab.id
}

output "vm01_private_ip" {
  value = azurerm_network_interface.vm01.private_ip_address
}

output "vm01_public_ip" {
  value = azurerm_public_ip.vm01.ip_address
}

output "vm02_private_ip" {
  value = azurerm_network_interface.vm02.private_ip_address
}

output "vm02_public_ip" {
  value = azurerm_public_ip.vm02.ip_address
}

output "vm01_private_dns" {
  value = "vm01.${azurerm_private_dns_zone.internal.name}"
}

output "vm02_private_dns" {
  value = "vm02.${azurerm_private_dns_zone.internal.name}"
}

output "private_dns_zone" {
  value = azurerm_private_dns_zone.internal.name
}

output "public_dns_name_servers" {
  value = var.enable_public_dns ? azurerm_dns_zone.public[0].name_servers : []
}

output "public_vm01_fqdn" {
  value = var.enable_public_dns ? "vm01.${azurerm_dns_zone.public[0].name}" : "Public DNS disabled"
}

output "public_vm02_fqdn" {
  value = var.enable_public_dns ? "vm02.${azurerm_dns_zone.public[0].name}" : "Public DNS disabled"
}
