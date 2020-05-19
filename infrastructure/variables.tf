variable "subscription_id" {
  type = string
}

variable "location" {
  type = string
}

variable "name" {
  type = string
}

variable "user" {
  type = string
}

variable "password" {
  type = string
}

variable "vm_size" {
  type = string
  default = "Standard_DS3_v2"
}

variable "storage_account_tier" {
  type    = string
  default = "Standard"
}

variable "storage_account_replication" {
  type    = string
  default = "LRS"
}
