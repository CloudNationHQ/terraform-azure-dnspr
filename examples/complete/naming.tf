locals {
  naming = {
    # lookup outputs to have consistent naming
    for type in local.naming_types : type => lookup(module.naming, type).name
  }

  naming_types = ["subnet", "network_security_group", "private_dns_resolver_outbound_endpoint", "private_dns_resolver_inbound_endpoint", "private_dns_resolver_dns_forwarding_ruleset", "private_dns_resolver_forwarding_rule", "private_dns_resolver_virtual_network_link"]
}
