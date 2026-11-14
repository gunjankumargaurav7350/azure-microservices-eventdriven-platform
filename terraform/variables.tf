variable "resource_group_name" {
  type        = string
  default     = "rg-microservices-eventdriven-prod"
  description = "Target Resource Group Name"
}

variable "location" {
  type        = string
  default     = "eastus"
  description = "Azure Region"
}

variable "tags" {
  type = map(string)
  default = {
    Environment  = "Production"
    Architecture = "Event-Driven-Microservices"
    Framework    = "Dapr"
    Owner        = "Gunjan Kumar Gaurav"
    ManagedBy    = "Terraform"
  }
}

variable "container_app_environments" {
  description = "Map of Container App Environments to deploy using for_each"
  type = map(object({
    log_analytics_workspace_name = string
    log_sku                      = optional(string, "PerGB2018")
    retention_in_days            = optional(number, 30)
    tags                         = optional(map(string), {})
  }))
  default = {
    "cae-eventdriven-prod" = {
      log_analytics_workspace_name = "law-containerapps-prod"
      log_sku                      = "PerGB2018"
      retention_in_days            = 30
      tags                         = { Tier = "ComputeEnvironment" }
    }
  }
}

variable "service_bus_namespaces" {
  description = "Map of Service Bus Namespaces, Topics, and Subscriptions to deploy using for_each"
  type = map(object({
    sku = optional(string, "Standard")
    topics = optional(map(object({})), {})
    subscriptions = optional(map(object({
      topic_name         = string
      max_delivery_count = optional(number, 5)
    })), {})
    tags = optional(map(string), {})
  }))
  default = {
    "sb-microservices-prod-01" = {
      sku = "Standard"
      topics = {
        "orders.v1" = {}
      }
      subscriptions = {
        "sub-payment-processor" = {
          topic_name         = "orders.v1"
          max_delivery_count = 5
        }
      }
      tags = { Backbone = "Messaging" }
    }
  }
}
