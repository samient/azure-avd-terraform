provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

resource "azurerm_virtual_desktop_host_pool" "example" {
  name                = "avd-hostpool"
  location            = var.location
  resource_group_name = var.resource_group_name
  type                = "Pooled"
  ...
}
