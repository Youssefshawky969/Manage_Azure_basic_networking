resource "azurerm_private_endpoint" "pe" {

  name                = "webapp-pe"
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = var.subnet_id

  private_service_connection {

    name                           = "webapp-connection"
    private_connection_resource_id = var.app_id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {

    name                 = "webapp-zone-group"
    private_dns_zone_ids = [var.private_dns_zone_id]
  }
}
