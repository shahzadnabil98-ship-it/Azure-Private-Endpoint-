# Netzwerkkarte für die VM im internen Workload-Subnetz
resource "azurerm_network_interface" "vm_nic" {
  name                = "nic-secure-vm"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal-config"
    subnet_id                     = azurerm_subnet.workload_subnet.id
    private_ip_address_allocation = "Dynamic"
    # Keine Public IP verknüpft!
  }
}

# Die Linux VM (Ubuntu 24.04 LTS auf garantierter Standard_B2s Hardware)
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm-secure-worker"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_D2s_v5" # <-- Auf D-Serie geändert
  admin_username      = "azureuser"
  # ... Rest bleibt gleich
  admin_password      = "Bananen!Frankfurt26" # Dein Passwort für den Bastion-Login

  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.vm_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}
