# Storage Account mit ZRS (Synchron gespiegelt über 3 Verfügbarkeitszonen)
resource "azurerm_storage_account" "storage" {
  name                     = "stlinkedinlab${random_string.unique_id.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "ZRS"

  public_network_access_enabled = true # <-- Temporär auf true setzen
}


# Erstellt eine logische Azure File Share im Speicher
resource "azurerm_storage_share" "fileshare" {
  name                 = "fileshare-secure-data"
  storage_account_name = azurerm_storage_account.storage.name # <-- Genau so will deine Version es haben!
  quota                = 50
}



# Zufälliger String, damit der Storage-Name weltweit einzigartig ist
resource "random_string" "unique_id" {
  length  = 6
  special = false
  upper   = false
}

# PRIVATE ENDPOINT FÜR BLOB
resource "azurerm_private_endpoint" "pe_blob" {
  name                = "pe-storage-blob"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.workload_subnet.id

  private_service_connection {
    name                           = "psc-blob-link"
    private_connection_resource_id = azurerm_storage_account.storage.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
}

# PRIVATE ENDPOINT FÜR AZURE FILES
resource "azurerm_private_endpoint" "pe_file" {
  name                = "pe-storage-file"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.workload_subnet.id

  private_service_connection {
    name                           = "psc-file-link"
    private_connection_resource_id = azurerm_storage_account.storage.id
    is_manual_connection           = false
    subresource_names              = ["file"]
  }
}
