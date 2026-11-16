terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "microservices_rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# -------------------------------------------------------------------------------------------------
# Modular Container Apps Environments using for_each
# -------------------------------------------------------------------------------------------------
module "container_app_environments" {
  source   = "./modules/container_apps_environment"
  for_each = var.container_app_environments

  resource_group_name          = azurerm_resource_group.microservices_rg.name
  location                     = azurerm_resource_group.microservices_rg.location
  environment_name             = each.key
  log_analytics_workspace_name = each.value.log_analytics_workspace_name
  log_sku                      = each.value.log_sku
  retention_in_days            = each.value.retention_in_days
  tags                         = merge(azurerm_resource_group.microservices_rg.tags, each.value.tags)
}

# -------------------------------------------------------------------------------------------------
# Modular Service Bus Namespaces using for_each
# -------------------------------------------------------------------------------------------------
module "service_bus" {
  source   = "./modules/service_bus"
  for_each = var.service_bus_namespaces

  resource_group_name = azurerm_resource_group.microservices_rg.name
  location            = azurerm_resource_group.microservices_rg.location
  namespace_name      = each.key
  sku                 = each.value.sku
  topics              = each.value.topics
  subscriptions       = each.value.subscriptions
  tags                = merge(azurerm_resource_group.microservices_rg.tags, each.value.tags)
}

