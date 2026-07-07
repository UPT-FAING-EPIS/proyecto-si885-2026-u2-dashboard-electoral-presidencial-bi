locals {
  name_prefix          = "${var.project_name}-${var.environment}"
  storage_account_name = substr(replace("${var.project_name}${var.environment}${random_string.suffix.result}", "-", ""), 0, 24)
  sql_location         = coalesce(var.sql_location, var.location)
}

resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "azurerm_resource_group" "main" {
  name     = "rg-${local.name_prefix}"
  location = var.location
}

resource "azurerm_storage_account" "data" {
  name                     = local.storage_account_name
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  blob_properties {
    versioning_enabled = true
  }
}

resource "azurerm_storage_container" "raw" {
  name                  = "raw-csv"
  storage_account_name  = azurerm_storage_account.data.name
  container_access_type = "private"
}

resource "azurerm_mssql_server" "main" {
  name                         = "sql-${local.name_prefix}-w3-${random_string.suffix.result}"
  resource_group_name          = azurerm_resource_group.main.name
  location                     = local.sql_location
  version                      = "12.0"
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_password
  minimum_tls_version          = "1.2"
}

resource "azurerm_mssql_firewall_rule" "client" {
  name             = "client-ip"
  server_id        = azurerm_mssql_server.main.id
  start_ip_address = var.allowed_ip_address
  end_ip_address   = var.allowed_ip_address
}

resource "azurerm_mssql_firewall_rule" "azure_services" {
  name             = "allow-azure-services"
  server_id        = azurerm_mssql_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_mssql_database" "dw" {
  name           = "Elecciones2026DW"
  server_id      = azurerm_mssql_server.main.id
  sku_name       = var.sql_database_sku
  zone_redundant = false
}

resource "azurerm_data_factory" "main" {
  name                = "adf-${local.name_prefix}-${random_string.suffix.result}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  identity {
    type = "SystemAssigned"
  }
}
