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
    forwarding_rulesets = optional(map(object({
      virtual_network_links = optional(map(object({
        virtual_network_id = string
      })))
      rules = optional(map(object({
      domain_name         = string
      enabled             = bool
      metadata            = optional(map(object))
      target_dns_servers  = map(object{
        ip_address  = string
        port        = optional(number)
        })
      })))
    })))
  })))
})
```

## Notes

Only port 53 can be set as the target port for the dns forward rule, therefore this will be set as default from the module if not provided.