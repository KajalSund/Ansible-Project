variable "rg_name" {
  type = string
}

variable "rg_location" {
  type = string
}

variable "windows_os_disk"{
  type = map(string)
}

variable "windows_os_info"{
  type = map(string)
}

variable "windows_avs"{
  type = string
}

variable "subnet_id" {
  type = string
}

variable "storage_account_uri" {
  type = string
}

variable "vm_count" {
  type = number
}

variable "extension_setting" {
  type = map(string)
}

variable "tags" {
  type = map(string)
}
