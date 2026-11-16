output "environment_id" {
  description = "Container App Environment Resource ID"
  value       = azurerm_container_app_environment.managed_env.id
}

output "container_app_environment_id" {
  description = "Alias for container app environment ID"
  value       = azurerm_container_app_environment.managed_env.id
}

output "container_app_fqdns" {
  description = "Map of Container App FQDNs"
  value       = { for k, v in azurerm_container_app.apps : k => v.latest_revision_fqdn }
}
