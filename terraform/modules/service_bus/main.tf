resource "azurerm_servicebus_namespace" "this" {
  name                = var.namespace_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  tags                = var.tags
}

resource "azurerm_servicebus_topic" "topics" {
  for_each     = var.topics
  name         = each.key
  namespace_id = azurerm_servicebus_namespace.this.id
}

resource "azurerm_servicebus_subscription" "subscriptions" {
  for_each           = var.subscriptions
  name               = each.key
  topic_id           = azurerm_servicebus_topic.topics[each.value.topic_name].id
  max_delivery_count = each.value.max_delivery_count
}

