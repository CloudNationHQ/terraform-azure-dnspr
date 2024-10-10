# private dns resolver
resource "azurerm_private_dns_resolver" "resolver" {
  name                = var.instance.name
  resource_group_name = coalesce(lookup(var.instance, "resource_group", null), var.resource_group)
  location            = coalesce(lookup(var.instance, "location", null), var.location)
  virtual_network_id  = var.instance.virtual_network_id
  tags                = try(var.instance.tags, var.tags, {})
}

# inbound endpoints
resource "azurerm_private_dns_resolver_inbound_endpoint" "inbound" {
  for_each = lookup(
    var.instance, "inbound_endpoints", {}
  )

  name = try(
    each.value.name, join("-", [var.naming.private_dns_resolver_inbound_endpoint, each.key])
  )

  private_dns_resolver_id = azurerm_private_dns_resolver.resolver.id
  location                = coalesce(lookup(var.instance, "location", null), var.location)

  dynamic "ip_configurations" {
    for_each = try(each.value.ip_configurations, {})
    content {
      private_ip_allocation_method = try(ip_configurations.value.private_ip_allocation_method, "Dynamic")
      subnet_id                    = ip_configurations.value.subnet_id
    }
  }
}

# outbound endpoints
resource "azurerm_private_dns_resolver_outbound_endpoint" "outbound" {
  for_each = lookup(
    var.instance, "outbound_endpoints", {}
  )

  name = try(
    each.value.name, join("-", [var.naming.private_dns_resolver_outbound_endpoint, each.key])
  )

  private_dns_resolver_id = azurerm_private_dns_resolver.resolver.id
  location                = coalesce(lookup(var.instance, "location", null), var.location)
  subnet_id               = each.value.subnet_id
}


# forwarding rulesets
resource "azurerm_private_dns_resolver_dns_forwarding_ruleset" "sets" {
  for_each = merge([
    for ep_key, ep in lookup(var.instance, "outbound_endpoints", {}) :
    lookup(ep, "forwarding_rulesets", null) != null ? {
      for ruleset_key, ruleset in ep.forwarding_rulesets : "${ep_key}-${ruleset_key}" => {
        name            = try(ruleset.name, null)
        outbound_ep_key = ep_key
        ruleset_key     = ruleset_key
      }
    } : {}
  ]...)

  name = coalesce(
    each.value.name,
    "${var.naming.private_dns_resolver_dns_forwarding_ruleset}-${each.value.ruleset_key}"
  )

  resource_group_name                        = var.instance.resource_group
  location                                   = var.instance.location
  private_dns_resolver_outbound_endpoint_ids = [azurerm_private_dns_resolver_outbound_endpoint.outbound[each.value.outbound_ep_key].id]
  tags                                       = try(var.instance.tags, {})
}

# forwarding rules
resource "azurerm_private_dns_resolver_forwarding_rule" "rules" {
  for_each = merge(flatten([
    for ep_key, ep in lookup(var.instance, "outbound_endpoints", {}) :
    lookup(ep, "forwarding_ruleset", null) != null ? [
      for ruleset_key, ruleset in lookup(ep, "forwarding_ruleset", {}) :
      lookup(ruleset, "rules", null) != null ? {
        for rule_key, rule in ruleset.rules : rule_key => merge(rule, {
          ep_key      = ep_key
          ruleset_key = ruleset_key
          rule_key    = rule_key
        })
      } : {}
    ] : []
  ])...)

  name = coalesce(
    lookup(each.value, "name", null),
    "${var.naming.private_dns_resolver_forwarding_rule}-${each.key}"
  )

  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.sets["${each.value.ep_key}-${each.value.ruleset_key}"].id
  domain_name               = each.value.domain_name
  enabled                   = each.value.state == "Enabled" ? true : false

  dynamic "target_dns_servers" {
    for_each = each.value.destination_ip_addresses
    content {
      ip_address = target_dns_servers.key
      port       = target_dns_servers.value
    }
  }
}
