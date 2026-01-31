resource "azurerm_public_ip" "pip" {
  count               = var.enable_vm ? 1 : 0
  name                = "landing-vm-ip"
  resource_group_name = var.rg_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "nic" {
  count               = var.enable_vm ? 1 : 0
  name                = "landing-vm-nic"
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip[0].id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  count               = var.enable_vm ? 1 : 0
  name                = "landing-vm"
  resource_group_name = var.rg_name
  location            = var.location
  size                = "Standard_D2s_v3"
  admin_username      = var.admin_user

  network_interface_ids = [
    azurerm_network_interface.nic[0].id
  ]

  admin_ssh_key {
    username   = var.admin_user
    public_key = file(var.ssh_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}
