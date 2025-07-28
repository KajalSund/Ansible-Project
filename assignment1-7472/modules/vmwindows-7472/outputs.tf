output "windows_hostname"{
  value = [for vm in azurerm_windows_virtual_machine.vmwindows: vm.computer_name]
}

output "windows_dns_labels"{
  value = [for pip in azurerm_public_ip.windows_pip: pip.domain_name_label]
}

output "windows_private_ips"{
  value = [for wnic in azurerm_network_interface.windows_nic: wnic.private_ip_address]
}

output "windows_public_ips"{
  value = [for pip in azurerm_public_ip.windows_pip: pip.ip_address]
}

output "vm_ids" {
  value = [for vm in azurerm_windows_virtual_machine.vmwindows: vm.id]
}