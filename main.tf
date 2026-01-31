resource "azurerm_resource_group" "hub" {
  name     = "hub-rg"
  location = var.location
}

resource "azurerm_resource_group" "spoke" {
  name     = "spoke-rg"
  location = var.location
}


# HUB NETWORK
module "hub_network" {

  depends_on = [
    azurerm_resource_group.hub
  ]
  source        = "./modules/network"
  rg_name       = "hub-rg"
  vnet_name     = "hub-vnet"
  address_space = ["10.0.0.0/16"]
  subnet_name   = "hub-public-subnet"
  subnet_prefix = "10.0.1.0/24"
  location      = var.location
}

# SPOKE NETWORK
module "spoke_network" {

  depends_on = [
    azurerm_resource_group.spoke
  ]
  source        = "./modules/network"
  rg_name       = "spoke-rg"
  vnet_name     = "spoke-vnet"
  address_space = ["10.1.0.0/16"]
  subnet_name   = "spoke-private-subnet"
  subnet_prefix = "10.1.1.0/24"
  location      = var.location
}

# HUB NSG
module "hub_nsg" {

  depends_on = [
    module.hub_network
  ]

  source    = "./modules/nsg"

  rg_name   = "hub-rg"
  nsg_name  = "hub-nsg"
  location  = var.location

  subnet_id = module.hub_network.subnet_id

  allow_ssh = true
}


# SPOKE NSG
module "spoke_nsg" {

  depends_on = [
    module.spoke_network
  ]

  source    = "./modules/nsg"

  rg_name   = "spoke-rg"
  nsg_name  = "spoke-web-nsg"
  location  = var.location

  subnet_id = module.spoke_network.subnet_id

  allow_web = true
}

# VM
module "landing_vm" {
  depends_on = [
    azurerm_resource_group.hub,
    module.hub_network
  ]
  source        = "./modules/compute"
  enable_vm     = var.enable_vm
  rg_name       = "hub-rg"
  subnet_id     = module.hub_network.subnet_id
  location      = var.location
  admin_user    = var.admin_username
  ssh_key_path  = var.ssh_key_path
}

# APP SERVICE
module "webapp" {
  depends_on = [azurerm_resource_group.spoke]
  source   = "./modules/appservice"
  rg_name  = "spoke-rg"
  location = var.location
}

# PRIVATE ENDPOINT

module "private_endpoint" {

  depends_on = [
    module.webapp,
    module.dns
  ]

  source = "./modules/private-endpoint"

  rg_name              = "spoke-rg"
  location             = var.location
  subnet_id            = module.spoke_network.subnet_id
  app_id               = module.webapp.app_id
  private_dns_zone_id  = module.dns.dns_id
}




# DNS
module "dns" {

  depends_on = [
    module.hub_network,
    module.spoke_network
  ]

  source = "./modules/dns"

  rg_name       = "spoke-rg"
  hub_vnet_id   = module.hub_network.vnet_id
  spoke_vnet_id = module.spoke_network.vnet_id
}


# PEERING
module "peering" {
  depends_on = [
    module.hub_network,
    module.spoke_network
  ]
  source        = "./modules/peering"
  hub_rg         = "hub-rg"
  hub_vnet_name  = module.hub_network.vnet_name
  hub_vnet_id    = module.hub_network.vnet_id
  spoke_rg       = "spoke-rg"
  spoke_vnet_name = module.spoke_network.vnet_name
  spoke_vnet_id   = module.spoke_network.vnet_id
}
