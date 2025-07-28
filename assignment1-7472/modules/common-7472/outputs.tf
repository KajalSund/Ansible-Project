output "log_analytics_workspace_name" {
  value = azurerm_log_analytics_workspace.law_7472.name
}

output "recovery_services_vault_name" {
  value = azurerm_recovery_services_vault.rsv_7472.name
}

output "storage_account_name" {
  value = azurerm_storage_account.storage_common_7472.name
}

output "storage_account_primary_blob_endpoint" {
  value = azurerm_storage_account.storage_common_7472.primary_blob_endpoint
}
