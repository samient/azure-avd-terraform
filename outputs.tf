output "hostpool_name" {
  value = azurerm_virtual_desktop_host_pool.hostpool.name
}

output "workspace_url" {
  value = "https://rdweb.wvd.microsoft.com/arm/webclient/index.html"
}