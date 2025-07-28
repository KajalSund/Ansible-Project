resource "azurerm_public_ip" "windows_pip" {
  count = var.vm_count
  name                = "${var.rg_name}-win-pip-${count.index}"
  location            = var.rg_location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  domain_name_label = "win-7472vm${count.index}"

  tags = var.tags
}

resource "azurerm_network_interface" "windows_nic" {
  count = var.vm_count
  name                = "${var.rg_name}-win-nic-${count.index}"
  location            = var.rg_location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "${var.rg_name}-win-ipconfig"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.windows_pip[count.index].id
  }

  tags = var.tags
}

resource "azurerm_windows_virtual_machine" "vmwindows" {
  count = var.vm_count
  name = "${var.rg_name}-win-vm-${count.index}"
  computer_name = "win-${count.index}-7472"
  location            = var.rg_location
  resource_group_name = var.rg_name
  size                = "Standard_B1ms"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  availability_set_id = azurerm_availability_set.windows_aset.id
  network_interface_ids = [
    azurerm_network_interface.windows_nic[count.index].id,
  ] 

  os_disk {
    name = "${var.rg_name}-os-disk-${count.index}"
    caching = var.windows_os_disk.caching
    disk_size_gb = var.windows_os_disk.disk_size_gb
    storage_account_type = var.windows_os_disk.storage_account_type
  }

  source_image_reference {
    publisher = var.windows_os_info.publisher
    offer     = var.windows_os_info.offer
    sku       = var.windows_os_info.sku
    version   = var.windows_os_info.version
  } 

  boot_diagnostics {
    storage_account_uri = var.storage_account_uri
  }

  tags = var.tags
}

resource "azurerm_availability_set" "windows_aset" {
  name                = var.windows_avs
  location            = var.rg_location
  resource_group_name = var.rg_name
  platform_update_domain_count = 5
  platform_fault_domain_count = 2
}

resource "azurerm_virtual_machine_extension" "windows_antimalware" {
  count = var.vm_count
  name                 = var.extension_setting.name
  virtual_machine_id   = azurerm_windows_virtual_machine.vmwindows[count.index].id
  publisher            = var.extension_setting.publisher
  type                 = var.extension_setting.type
  type_handler_version = var.extension_setting.type_handler_version

  settings = <<SETTINGS
  {
    "AntimalwareEnabled": true,
    "RealtimeProtectionEnabled": true,
    "ScheduledScanSettings": {
      "isEnabled": true,
      "day": 0,
      "time": 120
    }
  }
  SETTINGS
}