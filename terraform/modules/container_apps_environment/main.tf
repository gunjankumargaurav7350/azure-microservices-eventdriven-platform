resource "azurerm_log_analytics_workspace" "law_apps" {
  name                = var.log_analytics_workspace_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.log_sku
  retention_in_days   = var.retention_in_days
  tags                = var.tags
}

resource "azurerm_container_app_environment" "managed_env" {
  name                       = var.environment_name
  resource_group_name        = var.resource_group_name
  location                   = var.location
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law_apps.id
  tags                       = var.tags
}
