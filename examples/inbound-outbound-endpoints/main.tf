module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 0.1"

  groups = {
    demo = {
      name   = module.naming.resource_group.name_unique
      region = "germanywestcentral"
    }
  }
}

module "network" {
  source  = "cloudnationhq/vnet/azure"
  version = "~> 3.0"

  naming = local.naming

  vnet = {
    name           = module.naming.virtual_network.name
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
    cidr           = ["10.19.0.0/16"]

    subnets = {
      inbound = {
        cidr = ["10.19.100.0/27"]
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
        cidr = ["10.19.101.0/27"]
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
  version = "~> 0.1"

  naming = local.naming

  instance = {
    name               = module.naming.private_dns_resolver.name
    location           = module.rg.groups.demo.location
    resource_group     = module.rg.groups.demo.name
    virtual_network_id = module.network.vnet.id

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
