module "rgroup-7472" {
  source     = "./modules/rgroup-7472"
  rg_name = "rg_7472"
  rg_location = var.location
  tags = local.common_tags
}

module "network-7472" {
  source = "./modules/network-7472"
  rg_name = module.rgroup-7472.rg_name
  rg_location = module.rgroup-7472.rg_location

  vnet = "vnet_7472"
  vnet_space = ["10.0.0.0/16"]
  subnet = "subnet_7472"
  subnet_space = ["10.0.0.0/24"]

  security_group1 = {
      sg_name        = "nsg1_7472"
      rule1_name     = "rule1"
      rule1_priority = 100
      direction      = "Inbound"
      access         = "Allow"
      protocol       = "Tcp"
      rule1_dst      = "22"
      rule2_name     = "rule2"
      rule2_priority = 200
      rule2_dst      = "80"
      rule3_name     = "rule3"
      rule3_priority = 300
      rule3_dst      = "3389"
      rule4_name     = "rule4"
      rule4_priority = 400
      rule4_dst      = "5985"
  }
  tags = local.common_tags
}

module "common-7472" {
  source = "./modules/common-7472"
  rg_name = module.rgroup-7472.rg_name
  rg_location = module.rgroup-7472.rg_location

  log_analytics_workspace_name = "law7472"
  recovery_services_vault_name = "rsv7472"
  common_storage_account_name = "7472commonsa"

  tags = local.common_tags
}

module "vmlinux-7472" {
  source                 = "./modules/vmlinux-7472"
  prefix                 = "7472"
  location               = var.location
  rg_name                = module.rgroup-7472.rg_name
  subnet_id              = module.network-7472.subnet_id
  boot_diag_storage_uri = module.common-7472.storage_account_primary_blob_endpoint
  # ssh_public_key_path    = "~/.ssh/id_rsa.pub"
  # ssh_private_key_path   = "~/.ssh/id_rsa"
  ssh_public_key_path = "/Users/n01737472/.ssh/id_rsa_azure.pub"
  ssh_private_key_path = "/Users/n01737472/.ssh/id_rsa_azure"
  tags                   = local.common_tags
}

module "vmwindows-7472" {
  source = "./modules/vmwindows-7472"
  rg_name = module.rgroup-7472.rg_name
  rg_location = module.rgroup-7472.rg_location

  windows_os_disk = {
    caching = "ReadWrite"
    disk_size_gb = 128
    storage_account_type = "StandardSSD_LRS"
  }

  windows_os_info = {
    publisher = "MicrosoftWindowsServer"
    offer = "WindowsServer"
    sku = "2016-Datacenter"
    version = "latest"
  }

  extension_setting = {
    name = "IaaSAntimalware"
    publisher = "Microsoft.Azure.Security"
    type = "IaaSAntimalware"
    type_handler_version = "1.5"
  }

  storage_account_uri = module.common-7472.storage_account_primary_blob_endpoint
  windows_avs = "windows-aset"
  tags = local.common_tags

  subnet_id = module.network-7472.subnet_id
  vm_count = 1
}

module "database-7472" {
  source = "./modules/database-7472"
  rg_name = module.rgroup-7472.rg_name
  rg_location = module.rgroup-7472.rg_location

  db_server_setting = {
    sku_name     = "B_Standard_B1ms"
    sku_tier     = "Burstable"
    sku_capacity = 1
    sku_family   = "Gen5"
    storage_mb = 32768
    version = "11"
    administrator_login = "pgadmin"
    administrator_login_password = "H@Sh1CoR3!"

    ssl_enforcement_enabled = true
    public_network_access_enabled = true
    ssl_minimal_tls_version_enforced = "TLS1_2"

    auto_grow_enabled   = true
    backup_retention_days = 7
    geo_redundant_backup_enabled = false
  }

  tags = local.common_tags
}

module "datadisk-7472" {
  source = "./modules/datadisk-7472"
  rg_name = module.rgroup-7472.rg_name
  rg_location = module.rgroup-7472.rg_location

  vm_ids = concat(values(module.vmlinux-7472.vm_ids), module.vmwindows-7472.vm_ids)

  data_disk_setting = {
    storage_account_type = "Standard_LRS"
    create_option = "Empty"
    disk_size_gb = 10
  }

  data_disk_attach = {
    lun = 0
    caching = "ReadWrite"
  }

  disk_count = 4
  tags = local.common_tags
}

module "loadbalancer-7472" {
  source      = "./modules/loadbalancer-7472"
  rg_name     = module.rgroup-7472.rg_name
  rg_location = module.rgroup-7472.rg_location
  tags        = local.common_tags
  vm_nics     = [
    module.vmlinux-7472.nic_ids["7472-u-1"],
    module.vmlinux-7472.nic_ids["7472-u-2"],
    module.vmlinux-7472.nic_ids["7472-u-3"],
  ]
}

# Terraform null resource to run Ansible playbook
# This resource will execute the Ansible playbook after the VM is created and ready
# It uses a local-exec provisioner to run the ansible-playbook command

resource "null_resource" "run_ansible" {
  depends_on = [module.vmlinux-7472]

  triggers = {
    always_run = timestamp() 
  }

  provisioner "local-exec" {
    command = <<EOT
      sleep 30 && \
      ANSIBLE_HOST_KEY_CHECKING=False \
      ansible-playbook -i ansible/hosts \
      -u azureuser \
      --private-key=./downloaded_keys/id_rsa \
      ansible/7472-playbook.yml
    EOT
  }
}
