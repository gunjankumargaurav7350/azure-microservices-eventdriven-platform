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

variable "tags" {
  type        = map(string)
  default     = {}
}
