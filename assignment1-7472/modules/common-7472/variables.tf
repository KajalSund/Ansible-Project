variable "rg_name" {
  type = string
}

variable "rg_location" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "log_analytics_workspace_name" {
  type = string
}

variable "recovery_services_vault_name" {
  type = string
}

variable "common_storage_account_name" {
  type = string
}