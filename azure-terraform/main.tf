provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.project_id}-rg"
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.project_id}-vnet01"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.project_id}-subnet01"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "nic" {
  count               = var.vm_count
  name                = "${var.project_id}-nic-${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                    = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  count               = var.vm_count
  name                = "${var.project_id}-vm-${count.index}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_D2s_v3"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "windows-11"
    sku       = "win11-22h2-avd"
    version   = "latest"
  }
}

resource "azurerm_virtual_desktop_host_pool" "hostpool" {
  name                = "${var.project_id}-hostpool"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  type                = "Pooled"
  load_balancer_type  = "BreadthFirst"
  friendly_name       = "${var.project_id} Host Pool"
  validate_environment = true
}

resource "azurerm_virtual_desktop_application_group" "dag" {
  name                = "${var.project_id}-dag"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  host_pool_id        = azurerm_virtual_desktop_host_pool.hostpool.id
  type                = "Desktop"
  friendly_name       = "${var.project_id} DAG"
}

resource "azurerm_virtual_desktop_workspace" "workspace" {
  name                = "${var.project_id}-workspace"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  friendly_name       = "${var.project_id} Workspace"
  description         = "Workspace for ${var.project_id}"
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "assoc" {
  workspace_id         = azurerm_virtual_desktop_workspace.workspace.id
  application_group_id = azurerm_virtual_desktop_application_group.dag.id
}
