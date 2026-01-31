resource "azurerm_service_plan" "plan" {
  name                = "webapp-plan"
  resource_group_name = var.rg_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "app" {
  name                = "private-webapp-${random_integer.rand.result}"
  resource_group_name = var.rg_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.plan.id
  public_network_access_enabled = false

	site_config {
		always_on = true
  }
}

resource "random_integer" "rand" {
  min = 1000
  max = 9999
}
