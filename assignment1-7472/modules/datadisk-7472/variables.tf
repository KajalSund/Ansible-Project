variable "rg_name" {
  type = string
}

variable "rg_location" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "vm_ids" {
  type = list(string)
}

variable "disk_count" {
  type = number
}

variable "data_disk_setting" {
  type = map(string)
}

variable "data_disk_attach" {
  type = map(string)
}