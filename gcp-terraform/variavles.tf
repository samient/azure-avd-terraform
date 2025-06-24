variable "client_id" {
  type        = string
  description = "Azure client ID"
}

variable "client_secret" {
  type        = string
  description = "Azure client secret"
}

variable "tenant_id" {
  type        = string
  description = "Azure tenant ID"
}

variable "subscription_id" {
  type        = string
  description = "Azure subscription ID"
}

variable "location" {
  type        = string
  default     = "East US"
  description = "Azure region"
}

variable "project_id" {
  type        = string
  default     = "avdproj"
  description = "Project name prefix"
}

variable "admin_username" {
  type        = string
  default     = "azureadmin"
  description = "Admin username for VM"
}

variable "admin_password" {
  type        = string
  description = "Admin password for VM"
  sensitive   = true
}

variable "vm_count" {
  type        = number
  default     = 1
  description = "Number of VMs to create"
}
