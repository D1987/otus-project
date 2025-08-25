variable "zone" {
  type    = string
  default = "ru-central1-d"
}

variable "cloud_id" {
  type = string
}

variable "folder_id" {
  type = string
}

variable "service_account_id" {
  type = string
}

variable "service_account_key_file" {
  type    = string
  default = "key.json"
}

variable "network_id" {
  type = string
}