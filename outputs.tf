output "instance" {
  description = "contains private dns resolver instance configuration"
  value        = azurerm_private_dns_resolver.resolver
}

output "inbound_endpoints" {
  description = "contains private dns resolver inbound endpoints configuration"
  value        = azurerm_private_dns_resolver_inbound_endpoint.inbound
}

output "outbound_endpoints" {
  description = "contains private dns resolver outbound endpoints configuration"
  value        = azurerm_private_dns_resolver_outbound_endpoint.outbound
}

output "forwarding_rulesets" {
  description = "contains private dns resolver dns forwarding ruleset configuration"
  value        = azurerm_private_dns_resolver_dns_forwarding_ruleset.sets
}

output "virtual_network_links" {
  description = "contains private dns resolver dns virtual network links configuration"
  value        = azurerm_private_dns_resolver_virtual_network_link.links
}
