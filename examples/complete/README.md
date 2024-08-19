# Complete

This example highlights the complete usage.

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
      virtual_network_links = optional(map(object({
        virtual_network_id = string
      })))
    })))
  })))
})
```
