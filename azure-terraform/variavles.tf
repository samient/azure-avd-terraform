variable "location" {}
variable "project_id" {}
variable "vm_count" {}
variable "admin_username" {
  description = "Username for the AVD admin account"
  type        = string
}
variable "admin_password" {
  description = "Password for the AVD admin account"
  type        = string
  sensitive   = true
}
