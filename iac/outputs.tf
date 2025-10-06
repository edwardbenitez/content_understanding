output "resource_group_name" {
  value = azurerm_resource_group.this.id
}

output "workspace_name" {
  value = azurerm_ai_foundry.this.name
}
output "ai_service_endpoint" {
  value = azurerm_ai_services.this.endpoint
}