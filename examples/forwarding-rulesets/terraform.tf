terraform {
  required_version = "~> 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.61"
    }
    #azapi = {
    #source = "Azure/azapi"
    #}
  }
}

provider "azurerm" {
  features {}
}
