module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 1.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name
      location = "germanywestcentral"
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
  }
}

module "resolver" {
  source  = "cloudnationhq/dnspr/azure"
  version = "~> 1.0"

  instance = {
    name               = module.naming.private_dns_resolver.name
    location           = module.rg.groups.demo.location
    resource_group     = module.rg.groups.demo.name
    virtual_network_id = module.network.vnet.id
  }
}
