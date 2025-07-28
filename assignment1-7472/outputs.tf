output "rg_name" {
  value = module.rgroup-7472.rg_name
}

output "rg_location" {
  value = module.rgroup-7472.rg_location
}

output "vnet_name" {
  value = module.network-7472.vnet_name
}

output "subnet_name" {
  value = module.network-7472.subnet_name
}

output "log_analytics_workspace_name" {
  value       = module.common-7472.log_analytics_workspace_name
}

output "recovery_services_vault_name" {
  value       = module.common-7472.recovery_services_vault_name
}

output "storage_account_name" {
  value       = module.common-7472.storage_account_name
}

output "windows_hostname"{
  value = module.vmwindows-7472.windows_hostname
}

output "windows_dns_labels"{
  value = module.vmwindows-7472.windows_dns_labels
}

output "windows_private_ips"{
  value = module.vmwindows-7472.windows_private_ips
}

output "windows_public_ips"{
  value = module.vmwindows-7472.windows_public_ips
}

output "db_server_name" {
  value = module.database-7472.db_server_name
}

# Linux VM outputs
output "linux_hostnames" {
  value = module.vmlinux-7472.hostnames
}

output "linux_dns_names" {
  value = module.vmlinux-7472.dns_names
}

output "linux_private_ips" {
  value = module.vmlinux-7472.private_ips
}

output "linux_public_ips" {
  value = module.vmlinux-7472.public_ips
}

# Load Balancer output
output "load_balancer_name" {
  value = module.loadbalancer-7472.load_balancer_name
}

