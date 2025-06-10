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

module "network" {
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
        address_prefixes = ["10.19.100.0/27"]
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

module "dnsresolver" {
  source  = "cloudnationhq/dnspr/azure"
  version = "~> 3.0"

  naming = local.naming

  instance = {
    name                = module.naming.private_dns_resolver.name
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
    virtual_network_id  = module.network.vnet.id

    inbound_endpoints = {
      ep1 = {
        ip_configurations = {
          config1 = {
            subnet_id = module.network.subnets.inbound.id
          }
        }
      }
    }
    outbound_endpoints = {
      ep1 = {
        subnet_id = module.network.subnets.outbound.id
      }
    }
  }
}
