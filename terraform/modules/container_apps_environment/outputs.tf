output "container_app_environment_id" {
  value = azurerm_container_app_environment.managed_env.id
}

output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.law_apps.id
}
