output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "storage_account_name" {
  value = azurerm_storage_account.data.name
}

output "raw_container_name" {
  value = azurerm_storage_container.raw.name
}

output "sql_server_fqdn" {
  value = azurerm_mssql_server.main.fully_qualified_domain_name
}

output "sql_database_name" {
  value = azurerm_mssql_database.dw.name
}

output "data_factory_name" {
  value = azurerm_data_factory.main.name
}
