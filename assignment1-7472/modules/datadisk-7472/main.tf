resource "azurerm_managed_disk" "datadisk_7472" {
  count               = var.disk_count
  name                = "${var.rg_name}-datadisk-${count.index}"
  location            = var.rg_location
  resource_group_name = var.rg_name
  storage_account_type = var.data_disk_setting.storage_account_type
  create_option       = var.data_disk_setting.create_option
  disk_size_gb        = var.data_disk_setting.disk_size_gb

  tags = var.tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "datadisk_attach_7472" {
  count              = var.disk_count
  managed_disk_id    = azurerm_managed_disk.datadisk_7472[count.index].id
  virtual_machine_id = var.vm_ids[count.index]
  lun                = var.data_disk_attach.lun
  caching            = var.data_disk_attach.caching
}
