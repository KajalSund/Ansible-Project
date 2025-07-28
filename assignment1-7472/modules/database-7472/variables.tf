variable "rg_name" {
  type = string
}

variable "rg_location" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "db_server_setting" {
  type = map(string)
}