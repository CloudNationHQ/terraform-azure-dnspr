variable "resolver" {
  description = "contains all private dns resolver configuration"
  type = object({
    name                = string
    resource_group_name = optional(string, null)
    location            = optional(string, null)
    virtual_network_id  = string
    tags                = optional(map(string))
    inbound_endpoints = optional(map(object({
      name = optional(string, null)
      ip_configurations = optional(map(object({
        private_ip_allocation_method = optional(string, "Dynamic")
        private_ip_address           = optional(string, null)
        subnet_id                    = string
      })), {})
    })), {})
    outbound_endpoints = optional(map(object({
      name      = optional(string, null)
      subnet_id = string
      forwarding_rulesets = optional(map(object({
        name = optional(string, null)
        tags = optional(map(string), null)
        rules = optional(map(object({
          name        = optional(string, null)
          domain_name = string
          enabled     = optional(bool, null)
          metadata    = optional(map(string), null)
          target_dns_servers = map(object({
            ip_address = string
            port       = optional(number, 53)
          }))
        })), {})
        virtual_network_links = optional(map(object({
          name               = optional(string, null)
          metadata           = optional(map(string), null)
          virtual_network_id = string
        })), {})
      })), {})
    })), {})
  })

  validation {
    condition     = lookup(var.resolver, "location", null) != null || var.location != null
    error_message = "location must be set on var.resolver.location or on the module-level var.location."
  }

  validation {
    condition     = lookup(var.resolver, "resource_group_name", null) != null || var.resource_group_name != null
    error_message = "resource_group_name must be set on var.resolver.resource_group_name or on the module-level var.resource_group_name."
  }
}

variable "location" {
  description = "default azure region to be used."
  type        = string
  default     = null
}

variable "resource_group_name" {
  description = "default resource group to be used."
  type        = string
  default     = null
}

variable "tags" {
  description = "tags to be added to the resources"
  type        = map(string)
  default     = {}
}
