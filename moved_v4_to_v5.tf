moved {
  from = azurerm_private_dns_resolver.resolver
  to   = azurerm_private_dns_resolver.this
}

moved {
  from = azurerm_private_dns_resolver_inbound_endpoint.inbound
  to   = azurerm_private_dns_resolver_inbound_endpoint.this
}

moved {
  from = azurerm_private_dns_resolver_outbound_endpoint.outbound
  to   = azurerm_private_dns_resolver_outbound_endpoint.this
}

moved {
  from = azurerm_private_dns_resolver_dns_forwarding_ruleset.sets
  to   = azurerm_private_dns_resolver_dns_forwarding_ruleset.this
}

moved {
  from = azurerm_private_dns_resolver_forwarding_rule.rules
  to   = azurerm_private_dns_resolver_forwarding_rule.this
}

moved {
  from = azurerm_private_dns_resolver_virtual_network_link.links
  to   = azurerm_private_dns_resolver_virtual_network_link.this
}
