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
  name     = "rg-microservices-eventdriven-prod"
  location = "eastus"
  tags = {
    Environment = "Production"
    Architecture = "Event-Driven-Microservices"
    Framework    = "Dapr"
    Owner        = "Gunjan Kumar Gaurav"
  }
}

# -------------------------------------------------------------------------------------------------
# Azure Container Apps Environment with Dapr Instrumentation
# -------------------------------------------------------------------------------------------------
resource "azurerm_log_analytics_workspace" "law_apps" {
  name                = "law-containerapps-prod"
  resource_group_name = azurerm_resource_group.microservices_rg.name
  location            = azurerm_resource_group.microservices_rg.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "managed_env" {
  name                       = "cae-eventdriven-prod"
  resource_group_name        = azurerm_resource_group.microservices_rg.name
  location                   = azurerm_resource_group.microservices_rg.location
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law_apps.id
  tags                       = azurerm_resource_group.microservices_rg.tags
}

# -------------------------------------------------------------------------------------------------
# Azure Service Bus Messaging Backbone
# -------------------------------------------------------------------------------------------------
resource "azurerm_servicebus_namespace" "sb_ns" {
  name                = "sb-microservices-prod-01"
  resource_group_name = azurerm_resource_group.microservices_rg.name
  location            = azurerm_resource_group.microservices_rg.location
  sku                 = "Standard"
  tags                = azurerm_resource_group.microservices_rg.tags
}

resource "azurerm_servicebus_topic" "orders_topic" {
  name         = "orders.v1"
  namespace_id = azurerm_servicebus_namespace.sb_ns.id
}

resource "azurerm_servicebus_subscription" "payment_sub" {
  name               = "sub-payment-processor"
  topic_id           = azurerm_servicebus_topic.orders_topic.id
  max_delivery_count = 5
}
