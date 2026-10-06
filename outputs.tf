output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "vm_private_ip" {
  value       = azurerm_network_interface.vm_nic.private_ip_address
  description = "Die interne IP-Adresse deiner VM im VNet."
}

output "storage_account_name" {
  value = azurerm_storage_account.storage.name
}
