# private dns resolver
resource "azurerm_private_dns_resolver" "this" {
  resource_group_name = coalesce(
    var.resolver.resource_group_name, var.resource_group_name
  )

  location = coalesce(
    var.resolver.location, var.location
  )

  tags = coalesce(
    var.resolver.tags, var.tags
  )

  name               = var.resolver.name
  virtual_network_id = var.resolver.virtual_network_id

}

# inbound endpoints
resource "azurerm_private_dns_resolver_inbound_endpoint" "this" {
  for_each = var.resolver.inbound_endpoints

  name = coalesce(
    each.value.name, each.key
  )

  location = coalesce(
    var.resolver.location, var.location
  )

  private_dns_resolver_id = azurerm_private_dns_resolver.this.id

  dynamic "ip_configurations" {
    for_each = each.value.ip_configurations

    content {
      private_ip_allocation_method = ip_configurations.value.private_ip_allocation_method
      private_ip_address           = ip_configurations.value.private_ip_address
      subnet_id                    = ip_configurations.value.subnet_id
    }
  }

  tags = coalesce(
    var.resolver.tags, var.tags
  )
}

# outbound endpoints
resource "azurerm_private_dns_resolver_outbound_endpoint" "this" {
  for_each = var.resolver.outbound_endpoints

  name = coalesce(
    each.value.name, each.key
  )

  location = coalesce(
    var.resolver.location, var.location
  )

  private_dns_resolver_id = azurerm_private_dns_resolver.this.id
  subnet_id               = each.value.subnet_id

  tags = coalesce(
    var.resolver.tags, var.tags
  )
}

# forwarding rulesets
resource "azurerm_private_dns_resolver_dns_forwarding_ruleset" "this" {
  for_each = {
    for item in flatten([
      for ep_key, ep in var.resolver.outbound_endpoints : [
        for ruleset_key, ruleset in ep.forwarding_rulesets : {
          key             = "${ep_key}-${ruleset_key}"
          ruleset_key     = ruleset_key
          outbound_ep_key = ep_key
          name = coalesce(
            ruleset.name, ruleset_key
          )
        }
      ]
    ]) : item.key => item
  }

  name                                       = each.value.name
  private_dns_resolver_outbound_endpoint_ids = [azurerm_private_dns_resolver_outbound_endpoint.this[each.value.outbound_ep_key].id]

  resource_group_name = coalesce(
    var.resolver.resource_group_name, var.resource_group_name
  )

  location = coalesce(
    var.resolver.location, var.location
  )

  tags = coalesce(
    var.resolver.tags, var.tags
  )
}

# forwarding rules
resource "azurerm_private_dns_resolver_forwarding_rule" "this" {
  for_each = {
    for item in flatten([
      for ep_key, ep in var.resolver.outbound_endpoints : [
        for ruleset_key, ruleset in ep.forwarding_rulesets : [
          for rule_key, rule in ruleset.rules : {
            key         = "${ep_key}-${ruleset_key}-${rule_key}"
            ruleset_key = "${ep_key}-${ruleset_key}"
            domain_name = rule.domain_name
            enabled     = rule.enabled
            metadata    = rule.metadata
            name = coalesce(
              rule.name, rule_key
            )
            target_dns_servers = [
              for target_key, target in rule.target_dns_servers : {
                ip_address = target.ip_address
                port       = target.port
              }
            ]
          }
        ]
      ]
    ]) : item.key => item
  }

  name                      = each.value.name
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.this[each.value.ruleset_key].id
  domain_name               = each.value.domain_name
  enabled                   = each.value.enabled
  metadata                  = each.value.metadata

  dynamic "target_dns_servers" {
    for_each = each.value.target_dns_servers

    content {
      ip_address = target_dns_servers.value.ip_address
      port       = target_dns_servers.value.port
    }
  }
}

# virtual network links
resource "azurerm_private_dns_resolver_virtual_network_link" "this" {
  for_each = {
    for item in flatten([
      for ep_key, ep in var.resolver.outbound_endpoints : [
        for ruleset_key, ruleset in ep.forwarding_rulesets : [
          for link_key, link in ruleset.virtual_network_links : {
            key                = "${ep_key}-${ruleset_key}-${link_key}"
            ruleset_key        = "${ep_key}-${ruleset_key}"
            metadata           = link.metadata
            virtual_network_id = link.virtual_network_id
            name               = coalesce(link.name, link_key)
          }
        ]
      ]
    ]) : item.key => item
  }

  name                      = each.value.name
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.this[each.value.ruleset_key].id
  virtual_network_id        = each.value.virtual_network_id
  metadata                  = each.value.metadata
}
