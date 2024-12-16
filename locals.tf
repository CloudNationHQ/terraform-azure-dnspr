locals {
  rulesets = flatten([for ep_key, ep in lookup(var.instance, "outbound_endpoints", {}) :
    [for ruleset_key, ruleset in lookup(ep, "forwarding_rulesets", {}) : {
      key             = "${ep_key}-${ruleset_key}"
      name            = try(ruleset.name, "${var.naming.private_dns_resolver_dns_forwarding_ruleset}-${ruleset_key}")
      ruleset_key     = ruleset_key
      outbound_ep_key = ep_key
      tags            = coalesce(try(ruleset.tags, null), try(var.instance.tags, null), var.tags)
      }
    ]]
  )
  rules = flatten([for ep_key, ep in lookup(var.instance, "outbound_endpoints", {}) :
    [for ruleset_key, ruleset in lookup(ep, "forwarding_rulesets", {}) :
      [for rule_key, rule in lookup(ruleset, "rules", {}) : {
        key         = "${ep_key}-${ruleset_key}-${rule_key}"
        ruleset_key = ruleset_key
        ep_key      = ep_key
        name        = try(rule.name, "${var.naming.private_dns_resolver_forwarding_rule}-${ep_key}-${ruleset_key}-${rule_key}")
        domain_name = rule.domain_name
        enabled     = try(rule.enabled, null)
        metadata    = try(rule.metadata, null)
        target_dns_servers = [
          for target_key, target in rule.target_dns_servers : {
            key        = target_key
            ip_address = target.ip_address
            port       = try(target.port, 53) ## default to 53 if not set, only 53 is allowed and not optional even though it is optional according to the documentation
          }
        ]
        }
  ]]])

  links = flatten([for ep_key, ep in lookup(var.instance, "outbound_endpoints", {}) :
    [for ruleset_key, ruleset in lookup(ep, "forwarding_rulesets", {}) :
      [for link_key, link in lookup(ruleset, "virtual_network_links", {}) : {
        ruleset_key        = "${ep_key}-${ruleset_key}"
        link_key           = link_key
        name               = try(link.name, "${var.naming.private_dns_resolver_virtual_network_link}-${ep_key}-${ruleset_key}-${link_key}")
        metadata           = try(link.metadata, null)
        virtual_network_id = link.virtual_network_id
        }
  ]]])
}

