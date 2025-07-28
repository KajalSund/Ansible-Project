variable "rg_name" {
  type        = string
}

variable "rg_location" {
  type        = string
}

variable "tags" {
  type        = map(string)
}

variable "vm_nics" {
  type        = list(string)
}
