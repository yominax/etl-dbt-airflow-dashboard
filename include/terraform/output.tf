output "adls_access_key" {
  value     = azurerm_storage_account.lakehouse.primary_access_key
  sensitive = true
}

output "bronze_container_name" {
  value = azurerm_storage_container.layers["bronze"].name
}

output "silver_container_name" {
  value = azurerm_storage_container.layers["silver"].name
}

output "gold_container_name" {
  value = azurerm_storage_container.layers["gold"].name
}

# output "key_vault_id" {
#   value = azurerm_key_vault.vault.id
# }
