output "namespace_id" {
  value = azurerm_servicebus_namespace.this.id
}

output "topic_ids" {
  value = { for k, v in azurerm_servicebus_topic.topics : k => v.id }
}

output "subscription_ids" {
  value = { for k, v in azurerm_servicebus_subscription.subscriptions : k => v.id }
}
