variable "rg_name" {
  type = string
}

variable "rg_location" {
  type = string
}

variable "vnet" {
}

variable "vnet_space" {
}

variable "subnet" {
  type = string
}

variable "subnet_space" {
}

variable "security_group1" {
  type = map(string)
}

variable "tags" {
  type = map(string)
}