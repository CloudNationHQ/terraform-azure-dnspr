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

  tags = try(var.instance.tags, var.tags)
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

  tags = try(var.instance.tags, var.tags)
}


# forwarding rulesets
resource "azurerm_private_dns_resolver_dns_forwarding_ruleset" "sets" {
  for_each = local.rulesets != {} ? { for ruleset in local.rulesets : ruleset.key => ruleset } : {}

  name                                       = each.value.name
  resource_group_name                        = coalesce(lookup(var.instance, "resource_group", null), var.resource_group)
  location                                   = coalesce(lookup(var.instance, "location", null), var.location)
  private_dns_resolver_outbound_endpoint_ids = [azurerm_private_dns_resolver_outbound_endpoint.outbound[each.value.outbound_ep_key].id]
  tags                                       = each.value.tags
}

# forwarding rules
resource "azurerm_private_dns_resolver_forwarding_rule" "rules" {
  for_each = local.rules != {} ? { for rule in try(local.rules, {}) : rule.key => rule } : {}

  name                      = each.value.name
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.sets["${each.value.ep_key}-${each.value.ruleset_key}"].id
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
resource "azurerm_private_dns_resolver_virtual_network_link" "links" {
  for_each = local.links != {} ? { for link_key, link in local.links : link_key => link } : {}

  name                      = each.value.name
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.sets[each.value.ruleset_key].id
  virtual_network_id        = each.value.virtual_network_id
}
