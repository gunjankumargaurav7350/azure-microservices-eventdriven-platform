output "container_app_environment_ids" {
  description = "IDs of the Container App Environments"
  value       = { for k, v in module.container_app_environments : k => v.container_app_environment_id }
}

output "container_app_urls" {
  description = "Public ingress FQDNs of deployed container apps"
  value = {
    for env_name, env_mod in module.container_app_environments : env_name => env_mod.container_app_fqdns
  }
}

output "service_bus_namespace_ids" {
  description = "IDs of the Service Bus Namespaces"
  value       = { for k, v in module.service_bus : k => v.namespace_id }
}
