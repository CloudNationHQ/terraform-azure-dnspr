# Private Dns Resolver

This terraform module streamlines the creation of private dns resolver resources on the azure cloud platform, enabling users to manage and resolve private dns queries within their virtual networks. With this module, users can effortlessly provision a secure, scalable, and centralized dns resolution solution.

## Features

Supports the configuration of multiple inbound and outbound endpoints.

Allows multiple ip configurations on inbound endpoints.

Enables multiple forwarding rulesets and rules on outnound endpoints.

Utilization of terratest for robust validation.

Facilitates the integration of multiple virtual network links within a forwarding ruleset.

Offers three-tier naming hierarchy (explicit, convention-based, or key-based) for flexible resource management.

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 4.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 4.0)

## Resources

The following resources are used by this module:

- [azurerm_private_dns_resolver.resolver](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_resolver) (resource)
- [azurerm_private_dns_resolver_dns_forwarding_ruleset.sets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_resolver_dns_forwarding_ruleset) (resource)
- [azurerm_private_dns_resolver_forwarding_rule.rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_resolver_forwarding_rule) (resource)
- [azurerm_private_dns_resolver_inbound_endpoint.inbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_resolver_inbound_endpoint) (resource)
- [azurerm_private_dns_resolver_outbound_endpoint.outbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_resolver_outbound_endpoint) (resource)
- [azurerm_private_dns_resolver_virtual_network_link.links](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_resolver_virtual_network_link) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_instance"></a> [instance](#input\_instance)

Description: Contains private dns resolver instance configuration

Type:

```hcl
object({
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
```

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_location"></a> [location](#input\_location)

Description: default azure region to be used.

Type: `string`

Default: `null`

### <a name="input_naming"></a> [naming](#input\_naming)

Description: contains naming convention

Type: `map(string)`

Default: `{}`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: default resource group to be used.

Type: `string`

Default: `null`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: tags to be added to the resources

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_forwarding_rulesets"></a> [forwarding\_rulesets](#output\_forwarding\_rulesets)

Description: contains private dns resolver dns forwarding ruleset configuration

### <a name="output_inbound_endpoints"></a> [inbound\_endpoints](#output\_inbound\_endpoints)

Description: contains private dns resolver inbound endpoints configuration

### <a name="output_instance"></a> [instance](#output\_instance)

Description: contains private dns resolver instance configuration

### <a name="output_outbound_endpoints"></a> [outbound\_endpoints](#output\_outbound\_endpoints)

Description: contains private dns resolver outbound endpoints configuration

### <a name="output_virtual_network_links"></a> [virtual\_network\_links](#output\_virtual\_network\_links)

Description: contains private dns resolver dns virtual network links configuration
<!-- END_TF_DOCS -->

## Goals

For more information, please see our [goals and non-goals](./GOALS.md).

## Testing

For more information, please see our testing [guidelines](./TESTING.md)

## Notes

Using a dedicated module, we've developed a naming convention for resources that's based on specific regular expressions for each type, ensuring correct abbreviations and offering flexibility with multiple prefixes and suffixes.

Full examples detailing all usages, along with integrations with dependency modules, are located in the examples directory.

To update the module's documentation run `make doc`

## Contributors

We welcome contributions from the community! Whether it's reporting a bug, suggesting a new feature, or submitting a pull request, your input is highly valued.

For more information, please see our contribution [guidelines](./CONTRIBUTING.md). <br><br>

<a href="https://github.com/cloudnationhq/terraform-azure-dnspr/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=cloudnationhq/terraform-azure-dnspr" />
</a>

## License

MIT Licensed. See [LICENSE](https://github.com/cloudnationhq/terraform-azure-dnspr/blob/main/LICENSE) for full details.

## References

- [Documentation](https://learn.microsoft.com/en-us/azure/dns/dns-private-resolver-overview)
- [Rest Api](https://learn.microsoft.com/en-us/rest/api/dns/dnsresolver/operation-groups?view=rest-dns-dnsresolver-2020-04-01-preview)
