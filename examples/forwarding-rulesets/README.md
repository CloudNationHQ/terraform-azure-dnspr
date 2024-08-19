# Forwarding Rulesets

This deploys forwarding rulesets and rules

## Types

```hcl
instance = object({
  name               = string
  location           = string
  resource_group     = string
  virtual_network_id = string
  inbound_endpoints  = optional(map(object({
    ip_configurations = map(object({
      subnet_id = string
    }))
  })))
  outbound_endpoints = optional(map(object({
    subnet_id = string
    forwarding_ruleset = optional(map(object({
      rules = optional(map(object({
        domain_name              = string
        state                    = string
        destination_ip_addresses = map(string)
      })))
    })))
  })))
})
```
