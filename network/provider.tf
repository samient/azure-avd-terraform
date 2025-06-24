terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.33.0"
    }
  }
}

provider "azurerm" {
  features {}

  tenant_id       = "aa1995c3-8e3b-4c60-932e-a84a881812d8"
  subscription_id = "4bcee4f8-c7d8-4f7d-b516-7a3620080356"
}