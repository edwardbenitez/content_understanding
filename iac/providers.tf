terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
    azapi = {
      source = "Azure/azapi"
      version = "2.7.0"
    }
  }
}

provider "azurerm" {
    subscription_id = "a58781b3-4617-4c83-8957-15808341f36d"
  features {
    key_vault {
      recover_soft_deleted_key_vaults    = true
      purge_soft_delete_on_destroy       = false
      purge_soft_deleted_keys_on_destroy = false
    }
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azapi" {
  # Configuration options
}