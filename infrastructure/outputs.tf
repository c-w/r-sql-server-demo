output "storage_account_name" {
  value = azurerm_storage_account.demo.name
}

output "storage_account_key" {
  value = azurerm_storage_account.demo.primary_access_key
}

output "server_fqdn" {
  value = azurerm_public_ip.demo.fqdn
}
