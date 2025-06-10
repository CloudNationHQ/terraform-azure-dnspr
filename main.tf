# private dns resolver
resource "azurerm_private_dns_resolver" "resolver" {
  resource_group_name = coalesce(
    lookup(
      var.instance, "resource_group_name", null
    ), var.resource_group_name
  )

  location = coalesce(
    lookup(var.instance, "location", null
    ), var.location
  )

  name               = var.instance.name
  virtual_network_id = var.instance.virtual_network_id

  tags = coalesce(
    var.instance.tags, var.tags
  )
}

# inbound endpoints
resource "azurerm_private_dns_resolver_inbound_endpoint" "inbound" {
  for_each = lookup(
    var.instance, "inbound_endpoints", {}
  )

  name = coalesce(
    each.value.name, try(
      join("-", [var.naming.private_dns_resolver_inbound_endpoint, each.key]), null
    ), each.key
  )

  location = coalesce(
    lookup(var.instance, "location", null
    ), var.location
  )

  private_dns_resolver_id = azurerm_private_dns_resolver.resolver.id

  dynamic "ip_configurations" {
    for_each = try(
      each.value.ip_configurations, {}
    )

    content {
      private_ip_allocation_method = ip_configurations.value.private_ip_allocation_method
      private_ip_address           = ip_configurations.value.private_ip_address
      subnet_id                    = ip_configurations.value.subnet_id
    }
  }

  tags = coalesce(
    var.instance.tags, var.tags
  )
}

# outbound endpoints
resource "azurerm_private_dns_resolver_outbound_endpoint" "outbound" {
  for_each = lookup(
    var.instance, "outbound_endpoints", {}
  )

  name = coalesce(
    each.value.name, try(
      join("-", [var.naming.private_dns_resolver_outbound_endpoint, each.key]), null
    ), each.key
  )

  location = coalesce(
    lookup(var.instance, "location", null
    ), var.location
  )

  private_dns_resolver_id = azurerm_private_dns_resolver.resolver.id
  subnet_id               = each.value.subnet_id

  tags = coalesce(
    var.instance.tags, var.tags
  )
}

# forwarding rulesets
resource "azurerm_private_dns_resolver_dns_forwarding_ruleset" "sets" {
  for_each = {
    for item in flatten([
      for ep_key, ep in lookup(var.instance, "outbound_endpoints", {}) : [
        for ruleset_key, ruleset in lookup(ep, "forwarding_rulesets", {}) : {
          key             = "${ep_key}-${ruleset_key}"
          ruleset_key     = ruleset_key
          outbound_ep_key = ep_key
          name = coalesce(
            ruleset.name, try(
              join("-", [var.naming.private_dns_resolver_dns_forwarding_ruleset, ruleset_key]), null
            ), ruleset_key
          )
          tags = coalesce(
            var.instance.tags, var.tags
          )
        }
      ]
    ]) : item.key => item
  }

  name = each.value.name

  resource_group_name = coalesce(
    lookup(
      var.instance, "resource_group_name", null
    ), var.resource_group_name
  )

  location = coalesce(
    lookup(var.instance, "location", null
    ), var.location
  )
  private_dns_resolver_outbound_endpoint_ids = [azurerm_private_dns_resolver_outbound_endpoint.outbound[each.value.outbound_ep_key].id]

  tags = coalesce(
    var.instance.tags, var.tags
  )
}

# forwarding rules
resource "azurerm_private_dns_resolver_forwarding_rule" "rules" {
  for_each = {
    for item in flatten([
      for ep_key, ep in lookup(var.instance, "outbound_endpoints", {}) : [
        for ruleset_key, ruleset in lookup(ep, "forwarding_rulesets", {}) : [
          for rule_key, rule in lookup(ruleset, "rules", {}) : {
            key         = "${ep_key}-${ruleset_key}-${rule_key}"
            ruleset_key = "${ep_key}-${ruleset_key}"
            ep_key      = ep_key
            domain_name = rule.domain_name
            enabled     = rule.enabled
            metadata    = rule.metadata
            name = coalesce(
              rule.name, try(
                join("-", [var.naming.private_dns_resolver_forwarding_rule, rule_key]), null
              ), rule_key
            )
            target_dns_servers = [
              for target_key, target in rule.target_dns_servers : {
                key        = target_key
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
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.sets[each.value.ruleset_key].id
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
  for_each = {
    for item in flatten([
      for ep_key, ep in lookup(var.instance, "outbound_endpoints", {}) : [
        for ruleset_key, ruleset in lookup(ep, "forwarding_rulesets", {}) : [
          for link_key, link in lookup(ruleset, "virtual_network_links", {}) : {
            key                = "${ep_key}-${ruleset_key}-${link_key}"
            ruleset_key        = "${ep_key}-${ruleset_key}"
            link_key           = link_key
            metadata           = link.metadata
            virtual_network_id = link.virtual_network_id
            name = coalesce(
              link.name, try(
                join("-", [var.naming.private_dns_resolver_virtual_network_link, link_key]), null
              ), link_key
            )
          }
        ]
      ]
    ]) : item.key => item
  }

  name                      = each.value.name
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.sets[each.value.ruleset_key].id
  virtual_network_id        = each.value.virtual_network_id
  metadata                  = each.value.metadata
}
