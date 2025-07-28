resource "azurerm_postgresql_flexible_server" "pgsql_7472" {
  name                   = "pgsql-7472"
  location               = var.rg_location
  resource_group_name    = var.rg_name
  administrator_login    = var.db_server_setting.administrator_login
  administrator_password = var.db_server_setting.administrator_login_password
  sku_name               = var.db_server_setting.sku_name
  version                = var.db_server_setting.version
  zone                   = "1"  # optional, depending on region
  storage_mb             = var.db_server_setting.storage_mb

  backup_retention_days = var.db_server_setting.backup_retention_days
  geo_redundant_backup_enabled = var.db_server_setting.geo_redundant_backup_enabled
  
  private_dns_zone_id = null              # optional

  authentication {
    password_auth_enabled = true
  }

  maintenance_window {
    day_of_week  = 0
    start_hour   = 0
    start_minute = 0
  }

  tags = var.tags
}
