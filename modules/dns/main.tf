resource "azurerm_private_dns_zone" "dns" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = var.rg_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "hub_link" {
  name                  = "hub-link"
  resource_group_name   = var.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.dns.name
  virtual_network_id    = var.hub_vnet_id
}

resource "azurerm_private_dns_zone_virtual_network_link" "spoke_link" {
  name                  = "spoke-link"
  resource_group_name   = var.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.dns.name
  virtual_network_id    = var.spoke_vnet_id
}
