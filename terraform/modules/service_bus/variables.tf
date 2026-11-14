variable "resource_group_name" {
  type        = string
  description = "Target Resource Group"
}

variable "location" {
  type        = string
  description = "Azure Region"
}

variable "namespace_name" {
  type        = string
  description = "Service Bus Namespace Name"
}

variable "sku" {
  type        = string
  default     = "Standard"
}

variable "tags" {
  type        = map(string)
  default     = {}
}

variable "topics" {
  description = "Map of topics to create using for_each"
  type        = map(object({}))
  default     = {}
}

variable "subscriptions" {
  description = "Map of subscriptions to create using for_each"
  type = map(object({
    topic_name         = string
    max_delivery_count = optional(number, 5)
  }))
  default = {}
}
