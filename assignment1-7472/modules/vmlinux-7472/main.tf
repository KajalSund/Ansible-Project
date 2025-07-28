resource "azurerm_availability_set" "linux_avset" {
  name                         = "${var.prefix}-linux-avset"
  location                     = var.location
  resource_group_name          = var.rg_name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
  tags                         = var.tags
}

resource "azurerm_network_interface" "nic" {
  for_each = var.vm_map

  name                = "${each.key}-nic"
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip[each.key].id
  }

  tags = var.tags
}

resource "azurerm_public_ip" "public_ip" {
  for_each = var.vm_map

  name                = "${each.key}-pip"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = lower("vm-${each.key}-dns")
  tags                = var.tags
}

resource "azurerm_linux_virtual_machine" "vm" {
  for_each            = var.vm_map
  name                = each.key
  resource_group_name = var.rg_name
  location            = var.location
  size                = "Standard_B1ms"
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.nic[each.key].id
  ]
  availability_set_id = azurerm_availability_set.linux_avset.id

  admin_ssh_key {
    username   = "azureuser"
    public_key = file(var.ssh_public_key_path)
  }

  source_image_reference {
  publisher = "Canonical"
  offer     = "0001-com-ubuntu-server-focal"
  sku       = "20_04-lts"
  version   = "latest"
  }


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  boot_diagnostics {
    storage_account_uri = var.boot_diag_storage_uri
  }

  tags = var.tags
}

resource "azurerm_virtual_machine_extension" "network_watcher" {
  for_each                   = var.vm_map
  name                       = "NetworkWatcherAgent"
  virtual_machine_id         = azurerm_linux_virtual_machine.vm[each.key].id
  publisher                  = "Microsoft.Azure.NetworkWatcher"
  type                       = "NetworkWatcherAgentLinux"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
}

resource "azurerm_virtual_machine_extension" "azure_monitor" {
  for_each                   = var.vm_map
  name                       = "AzureMonitorLinuxAgent"
  virtual_machine_id         = azurerm_linux_virtual_machine.vm[each.key].id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
}

resource "null_resource" "display_hostname" {
  for_each = var.vm_map
}