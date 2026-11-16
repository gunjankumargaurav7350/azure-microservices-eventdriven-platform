variable "resource_group_name" {
  type        = string
  description = "Target Resource Group"
}

variable "location" {
  type        = string
  description = "Azure Region"
}

variable "environment_name" {
  type        = string
  description = "Container App Environment Name"
}

variable "log_analytics_workspace_name" {
  type        = string
  description = "Log Analytics Workspace Name"
}

variable "log_sku" {
  type        = string
  default     = "PerGB2018"
}

variable "retention_in_days" {
  type        = number
  default     = 30
}

variable "container_apps" {
  type = map(object({
    image        = string
    cpu          = number
    memory       = string
    min_replicas = optional(number, 1)
    max_replicas = optional(number, 5)
    target_port  = optional(number, 8000)
    enable_dapr  = optional(bool, true)
    env = optional(list(object({
      name  = string
      value = string
    })), [])
  }))
  description = "Map of container apps managed via for_each"
  default = {
    "order-service" = {
      image        = "ghcr.io/gunjankumargaurav7350/order-service:latest"
      cpu          = 0.5
      memory       = "1.0Gi"
      min_replicas = 1
      max_replicas = 5
      target_port  = 8000
      enable_dapr  = true
    }
  }
}

variable "tags" {
  type        = map(string)
  default     = {}
}
