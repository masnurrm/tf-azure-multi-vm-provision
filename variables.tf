variable "vm_count" {
  type        = number
  default     = 3
}

variable "resource_group_name" {
  type        = string
  default     = "rg-atn-dev-sea-001"
}

variable "location" {
  type        = string
  default     = "Southeast Asia"
}

variable "admin_username" {
  type        = string
}

variable "admin_password" {
  type        = string
  sensitive   = true
}

variable "subnet_id" {
  type        = string
}

variable "vnet_name" {
  type        = string
  default     = "vnet-atn-dev-sea"
}

variable "subnet_name" {
  type        = string
  default     = "subnet-atn-dev-sea"
}
