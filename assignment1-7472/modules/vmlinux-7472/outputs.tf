output "hostnames" {
  value = [for vm in azurerm_linux_virtual_machine.vm : vm.computer_name]
}

output "private_ips" {
  value = { for key, nic in azurerm_network_interface.nic : key => nic.ip_configuration[0].private_ip_address }
}

output "public_ips" {
  value = { for key, pip in azurerm_public_ip.public_ip : key => pip.ip_address }
}

output "dns_names" {
  value = { for key, pip in azurerm_public_ip.public_ip : key => pip.fqdn }
}
output "vm_ids" {
  value = { for k, v in azurerm_linux_virtual_machine.vm : k => v.id }
}
output "nic_ids" {
  value = { for k, nic in azurerm_network_interface.nic : k => nic.id }
}
