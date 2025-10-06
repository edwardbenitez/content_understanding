locals {
  rg = {
    name     = "${var.rg_prefix}-${random_string.name.result}-rg"
    location = var.rg_location

  }
  kv = {
    name = "${var.rg_prefix}-${random_string.name.result}-kv"
    sku  = "standard"
  }
  storage_account = {
    name             = "${var.rg_prefix}${random_string.name.result}sa"
    tier             = "Standard"
    replication_type = "LRS"
  }
  ai_service = {
    name      = "${var.rg_prefix}-${random_string.name.result}-ai"
    sku       = "S0"
    subdomain = "${var.rg_prefix}${random_string.name.result}ai"
  }
  ai_services_hub = {
    name          = "${var.rg_prefix}-${random_string.name.result}-aih"
    identity_type = "SystemAssigned"
  }
  ai_services_project = {
    name          = "${var.rg_prefix}-${random_string.name.result}-aip"
    identity_type = "SystemAssigned"
  }
  ai_service_conn_ai_proj = {
    name      = "${var.rg_prefix}-${random_string.name.result}-ai-conn"
  }
}