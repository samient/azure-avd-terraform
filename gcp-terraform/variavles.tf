variable "client_id" {
  type        = string
  description = "AZURE_CLIENT_ID"
}

variable "client_secret" {
  type        = string
  description = "AZURE_CLIENT_SECRET"
}

variable "tenant_id" {
  type        = string
  description = "AZURE_TENANT_ID"
}

variable "subscription_id" {
  type        = string
  description = "AZURE_SUBSCRIPTION_ID"
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
