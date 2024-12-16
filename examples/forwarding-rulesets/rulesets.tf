locals {
  forwarding_rulesets = {
    ruleset1 = {
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
    }
    ruleset2 = {
      rules = {
        rule1 = {
          domain_name = "test.com."
          target_dns_servers = {
            target1 = {
              ip_address = "10.10.0.1"
            }
            target2 = {
              ip_address = "10.10.0.2"
              port       = 53
            }
          }
        }
      }
    }
  }
}
