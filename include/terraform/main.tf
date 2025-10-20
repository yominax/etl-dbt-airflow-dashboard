#########################################
# Terraform Infrastructure for Azure Data Pipeline
#########################################

# Random prefix to ensure unique resource naming
resource "random_pet" "unique_suffix" {
  length = 1
}

# Resource Group
resource "azurerm_resource_group" "data_rg" {
  name     = "${random_pet.unique_suffix.id}-rg-etl-pipeline"
  location = "centralindia"
}

# Get current Azure Client Config
data "azurerm_client_config" "me" {}

# Azure Data Lake Storage Account
resource "azurerm_storage_account" "lakehouse" {
  name                     = "${random_pet.unique_suffix.id}storagedatapipeline"
  resource_group_name      = azurerm_resource_group.data_rg.name
  location                 = azurerm_resource_group.data_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = true
}

# Create Storage Containers (bronze, silver, gold)
resource "azurerm_storage_container" "layers" {
  for_each              = toset(["bronze", "silver", "gold"])
  name                  = "${random_pet.unique_suffix.id}-${each.value}"
  storage_account_id    = azurerm_storage_account.lakehouse.id
  container_access_type = "private"
}

# Databricks Workspace
resource "azurerm_databricks_workspace" "workspace" {
  name                = "${random_pet.unique_suffix.id}-dbx-etlpipeline"
  location            = azurerm_resource_group.data_rg.location
  resource_group_name = azurerm_resource_group.data_rg.name
  sku                 = "standard"
}

# Key Vault
resource "azurerm_key_vault" "vault" {
  name                = "${random_pet.unique_suffix.id}-vault-etlpipeline"
  location            = azurerm_resource_group.data_rg.location
  resource_group_name = azurerm_resource_group.data_rg.name
  tenant_id           = data.azurerm_client_config.me.tenant_id
  sku_name            = "standard"
}

# User Key Vault Access Policy
resource "azurerm_key_vault_access_policy" "main_user" {
  key_vault_id = azurerm_key_vault.vault.id
  tenant_id    = data.azurerm_client_config.me.tenant_id
  object_id    = data.azurerm_client_config.me.object_id

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete",
    "Recover",
    "Backup",
    "Restore",
    "Purge"
  ]
}

# Azure Data Lake Gen2 Filesystem (used by Synapse)
resource "azurerm_storage_data_lake_gen2_filesystem" "fs_lake" {
  name               = "${random_pet.unique_suffix.id}-filesystem"
  storage_account_id = azurerm_storage_account.lakehouse.id
}

# Synapse Workspace
resource "azurerm_synapse_workspace" "synapse_ws" {
  name                                 = "${random_pet.unique_suffix.id}-synapse-etlpipeline"
  location                             = azurerm_resource_group.data_rg.location
  resource_group_name                  = azurerm_resource_group.data_rg.name
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.fs_lake.id
  sql_administrator_login              = "adminsynapse"
  sql_administrator_login_password     = "SecurePass123!" # use tfvars in production

  identity {
    type = "SystemAssigned"
  }
}

# Role assignment for Synapse (Contributor)
resource "azurerm_role_assignment" "synapse_contributor" {
  scope                = azurerm_resource_group.data_rg.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_synapse_workspace.synapse_ws.identity[0].principal_id
}

# Role assignment for Synapse access to Data Lake
resource "azurerm_role_assignment" "synapse_storage_access" {
  scope                = azurerm_storage_account.lakehouse.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_synapse_workspace.synapse_ws.identity[0].principal_id
}
