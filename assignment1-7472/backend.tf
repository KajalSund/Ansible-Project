terraform {
  backend "azurerm" {
    resource_group_name   = "tfstaten01737472RG"
    storage_account_name  = "tfstaten01737472sa"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}
