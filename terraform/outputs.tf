output "container_app_environment_ids" {
  description = "IDs of the Container App Environments"
  value       = { for k, v in module.container_app_environments : k => v.container_app_environment_id }
}

output "service_bus_namespace_ids" {
  description = "IDs of the Service Bus Namespaces"
  value       = { for k, v in module.service_bus : k => v.namespace_id }
}
