locals {
  forwarding_rulesets = {
    ruleset1 = {
      rules = {
        rule1 = {
          domain_name = "example.com."
          state       = "Enabled"
          destination_ip_addresses = {
            "10.1.1.1" = "53"
            "10.1.1.2" = "53"
          }
        },
        rule2 = {
          domain_name = "example2.com."
          state       = "Enabled"
          destination_ip_addresses = {
            "10.2.2.2" = "53"
          }
        }
      }
    }
  }
}
