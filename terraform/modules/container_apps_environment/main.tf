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

resource "azurerm_container_app" "apps" {
  for_each                     = var.container_apps
  name                         = each.key
  container_app_environment_id = azurerm_container_app_environment.managed_env.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  template {
    container {
      name   = each.key
      image  = each.value.image
      cpu    = each.value.cpu
      memory = each.value.memory

      dynamic "env" {
        for_each = each.value.env
        content {
          name  = env.value.name
          value = env.value.value
        }
      }
    }

    min_replicas = each.value.min_replicas
    max_replicas = each.value.max_replicas
  }

  ingress {
    external_enabled = true
    target_port      = each.value.target_port
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  dynamic "dapr" {
    for_each = each.value.enable_dapr ? [1] : []
    content {
      app_id   = each.key
      app_port = each.value.target_port
    }
  }

  tags = var.tags
}
