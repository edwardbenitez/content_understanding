# Random pet to be used in resource group name
resource "random_pet" "rg_name" {
  prefix = var.rg_prefix
}

# Create a resource group
resource "azurerm_resource_group" "this" {
  location = var.rg_location
  name     = local.rg.name
}

# Retrieve information about the current Azure client configuration
data "azurerm_client_config" "current" {}

# Generate random value for unique resource naming
resource "random_string" "name" {
  length  = 8
  lower   = true
  numeric = false
  special = false
  upper   = false
}

# Create an Azure Key Vault resource
resource "azurerm_key_vault" "this" {
  name                     = local.kv.name                                # Name of the Key Vault
  location                 = azurerm_resource_group.this.location         # Location from the resource group
  resource_group_name      = azurerm_resource_group.this.name             # Resource group name
  tenant_id                = data.azurerm_client_config.current.tenant_id # Azure tenant ID
  sku_name                 = local.kv.sku                                 # SKU tier for the Key Vault
  purge_protection_enabled = true                                         # Enables purge protection to prevent accidental deletion
}

# Assign "Key Vault Secrets Officer" role to the current user for accessing secrets in the Key Vault
resource "azurerm_role_assignment" "rbac-kv-secrets" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

# Create an Azure Storage Account
resource "azurerm_storage_account" "this" {
  name                     = local.storage_account.name          # Storage account name
  location                 = azurerm_resource_group.this.location   # Location from the resource group
  resource_group_name      = azurerm_resource_group.this.name       # Resource group name
  account_tier             = local.storage_account.tier             # Performance tier
  account_replication_type = local.storage_account.replication_type # Locally-redundant storage replication
}

# Deploy Azure AI Services resource
resource "azurerm_ai_services" "this" {
  name                  = local.ai_service.name                # AI Services resource name
  location              = azurerm_resource_group.this.location # Location from the resource group
  resource_group_name   = azurerm_resource_group.this.name     # Resource group name
  sku_name              = local.ai_service.sku                 # Pricing SKU tier
  custom_subdomain_name = local.ai_service.subdomain           # Custom subdomain name
}

# Create Azure AI Foundry service (HUB)
resource "azurerm_ai_foundry" "this" {
  name                = local.ai_services_hub.name           # AI Foundry service name
  location            = azurerm_ai_services.this.location # Location from the AI Services resource
  resource_group_name = azurerm_resource_group.this.name     # Resource group name
  storage_account_id  = azurerm_storage_account.this.id      # Associated storage account
  key_vault_id        = azurerm_key_vault.this.id         # Associated Key Vault

  identity {
    type = local.ai_services_hub.identity_type # Enable system-assigned managed identity
  }
  lifecycle {
    ignore_changes = [tags] # Ignore changes to tags to prevent unnecessary updates
  }
}

# Create an AI Foundry Project within the AI Foundry service
resource "azurerm_ai_foundry_project" "this" {
  name               = local.ai_services_project.name      # Project name
  location           = azurerm_ai_foundry.this.location # Location from the AI Foundry service
  ai_services_hub_id = azurerm_ai_foundry.this.id       # Associated AI Foundry service

  identity {
    type = local.ai_services_project.identity_type # Enable system-assigned managed identity
  }
  lifecycle {
    ignore_changes = [tags] # Ignore changes to tags to prevent unnecessary updates
  }
}
# Needed to interact with content undesrstanding analyzers
# action Microsoft.CognitiveServices/accounts/analyzers/analyzers/write
# is required
# not working
# resource "azurerm_role_assignment" "rbac-rg-ai-user" {
#   scope                = azurerm_ai_foundry_project.this.id
#   role_definition_name = "Azure AI User"
#   principal_id         = data.azurerm_client_config.current.object_id
# }

#new
resource "azurerm_role_assignment" "rbac-rg-ai-user" {
  scope                = azurerm_resource_group.this.id
  role_definition_name = "Azure AI User"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azapi_resource" "ai_service_conn_ai_proj" {
  type = "Microsoft.MachineLearningServices/workspaces/connections@2025-07-01-preview"
  name = local.ai_service_conn_ai_proj.name
  parent_id = azurerm_ai_foundry_project.this.id
  body = {
    properties = {
      category = "AIServices"
      isSharedToAll = false
      sharedUserList = []
      target = azurerm_ai_services.this.endpoint
      useWorkspaceManagedIdentity = true
      metadata: {
        ApiType = "Azure"
        ResourceId = azurerm_ai_services.this.id
        Location = azurerm_ai_services.this.location
        kind = "AIServices"
        ApiVersion = "2023-07-01-preview"
        DeploymentApiVersion = "2023-10-01-preview"
      }
      authType = "AAD" # Possible values include: 'AAD', 'Key'
      // For remaining properties, see WorkspaceConnectionPropertiesV2 objects
    }
  }
}