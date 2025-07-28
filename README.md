# Ansible-Project
# Terraform-Based Azure Infrastructure Deployment with Ansible Automation

This project provisions a complete Azure infrastructure using **Terraform** and configures it using **Ansible**. It supports scalable Linux and Windows virtual machine deployments, networking, storage, load balancing, and monitoring resources. The entire setup is designed to be **modular, reusable, parameterized, and non-interactive**.

## Project Features

### Terraform:

* Modularized structure for maintainability and reuse
* Remote backend configuration for centralized state management
* Scalable infrastructure:

  * Linux VMs provisioned using `for_each`
  * Windows VMs provisioned using `count`
* Availability sets for high availability
* Use of `locals` for dynamic tagging and consistent naming
* `null_resource` to trigger Ansible playbooks post-deployment
* Outputs for all critical resources

### Ansible:

* Role-based structure for automation and configuration management
* Automated configuration of:

  * System profiles and user creation
  * Disk partitioning and mounting
  * Apache Web Server setup with Load Balancer integration
* Idempotent and non-interactive execution

## Resources Created by Terraform

* Resource Group
* Virtual Network and Subnets
* Linux and Windows Virtual Machines
* Public and Private IPs
* FQDNs and Hostnames
* Load Balancer
* Data Disks for Linux VMs
* Azure SQL Database
* Storage Account and Recovery Services Vault
* Log Analytics Workspace

## Prerequisites

* Azure CLI configured
* Terraform installed (v1.3.0 or newer)
* Ansible installed (tested with v2.15+)
* Active Azure subscription

## Getting Started

### Terraform Workflow

```bash
# 1. Clone the repository
$ git clone https://github.com/KajalSund/Ansible-Project
$ cd Ansible-Project/assignment1-7472

# 2. Initialize Terraform
$ terraform init

# 3. Review the execution plan
$ terraform plan

# 4. Apply the configuration
$ terraform apply --auto-approve

# 5. To destroy the infrastructure
$ terraform destroy
```

### Ansible Workflow (Automatically Triggered Post Terraform Apply)

* The Ansible playbook is triggered by a `null_resource` using `local-exec` in the Terraform configuration.
* You can also run it manually:

```bash
cd ansible
ansible-playbook -i ansible/hosts ansible/7472_playbook.yml --private-key ansible/downloaded_keys/id_rsa
```

## Ansible Playbook Roles

* `profile`: Configure user profile and hostname banner
* `users`: Create and configure users
* `disks`: Partition and mount data disks
* `apache`: Install and configure Apache Web Server


## Outputs

After successful deployment:

* Hostnames and FQDNs for Linux and Windows VMs
* Private and public IP addresses
* Virtual Network, Subnets, and Load Balancer name


## Learnings and Highlights

* Designed a full-stack, cloud-native infrastructure using Terraform modules
* Automated system configuration with Ansible using roles and handlers
* Learned integration between Terraform and Ansible using `null_resource`
* Built a reproducible infrastructure using best practices for DevOps and IaC

## Demo Checklist

* [x] SSH login to Linux VMs as `user100` with private key
* [x] Apache setup verified with Load Balancer FQDN
* [x] Disk mounted and verified using `df -Th`
* [x] Syslog and timezone updates applied

---

**Note:** Ensure your `.ssh` key permissions are properly set before running SSH or Ansible. Use `chmod 600 downloaded_keys/id_rsa`.
