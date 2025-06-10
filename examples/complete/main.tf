module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.24"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 2.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = "germanywestcentral"
    }
  }
}

module "network_dnspr" {
  source  = "cloudnationhq/vnet/azure"
  version = "~> 9.0"

  naming = local.naming

  vnet = {
    name                = module.naming.virtual_network.name
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
    address_space       = ["10.19.0.0/16"]

    subnets = {
      inbound = {
        address_prefixes = ["10.19.99.0/27"]
        delegations = {
          dns = {
            name = "Microsoft.Network/dnsResolvers"
            actions = [
              "Microsoft.Network/virtualNetworks/subnets/join/action"
            ]
          }
        }
      }
      outbound = {
        address_prefixes = ["10.19.101.0/27"]
        delegations = {
          dns = {
            name = "Microsoft.Network/dnsResolvers"
            actions = [
              "Microsoft.Network/virtualNetworks/subnets/join/action"
            ]
          }
        }
      }
    }
  }
}

module "network_spoke" {
  source  = "cloudnationhq/vnet/azure"
  version = "~> 9.0"

  naming = local.naming

  vnet = {
    name                = "vnet-demo-res2"
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
    address_space       = ["10.20.0.0/16"]
  }
}

module "dnsresolver" {
  source  = "cloudnationhq/dnspr/azure"
  version = "~> 3.0"

  naming = local.naming

  instance = {
    name                = module.naming.private_dns_resolver.name
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
    virtual_network_id  = module.network_dnspr.vnet.id

    inbound_endpoints = {
      ep1 = {
        ip_configurations = {
          config1 = {
            subnet_id = module.network_dnspr.subnets.inbound.id
          }
        }
      }
    }
    outbound_endpoints = {
      ep1 = {
        subnet_id = module.network_dnspr.subnets.outbound.id
        forwarding_rulesets = {
          ruleset1 = {
            virtual_network_links = {
              link1 = {
                virtual_network_id = module.network_spoke.vnet.id
              }
            }
            rules = {
              rule1 = {
                domain_name = "example.com."
                enabled     = true
                target_dns_servers = {
                  target1 = {
                    ip_address = "10.1.1.1"
                    port       = 53
                  }
                  target2 = {
                    ip_address = "10.1.1.2"
                  }
                }
              }
              rule2 = {
                domain_name = "example2.com."
                target_dns_servers = {
                  target1 = {
                    ip_address = "10.2.2.2"
                    port       = 53
                  }
                }
              }
            }
            tags = {
              ruleset_tag = "ruleset1"
            }
          }
        }
      }
    }
    tags = {
      environment = "demo"
    }
  }
}
