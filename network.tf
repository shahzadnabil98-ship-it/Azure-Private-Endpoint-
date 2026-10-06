# Ressourcengruppe (Zentral für alle Komponenten)
resource "azurerm_resource_group" "rg" {
  name     = "rg-linkedin-lab-prod"
  location = "northeurope" # Irland (Sehr hohe Verfügbarkeit)
}

# Das Virtuelle Netzwerk (VNet)
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-core-prod"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Subnetz für Workloads (VM & Private Endpoints)
resource "azurerm_subnet" "workload_subnet" {
  name                 = "sn-workloads"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# ZWINGEND FÜR BASTION: Exakter Name erforderlich
resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/26"]
}

# Öffentliche IP für den Bastion Proxy
resource "azurerm_public_ip" "bastion_pip" {
  name                = "pip-bastion-secure"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Der Azure Bastion Host
resource "azurerm_bastion_host" "bastion" {
  name                = "bastion-secure-access"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                 = "bastion-ip-config"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }
}
