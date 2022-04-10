locals {
  sub_name      = "Subscription_C"
  address_space = "10.0.3.0/24"
}

provider "azurerm" {
  features {}
  subscription_id            = "619964d5-fa2d-4bb4-877c-b2c02b94cf15"
  skip_provider_registration = true
  alias                      = "Subscription_C"
}

resource "azurerm_resource_group" "example" {
  name     = local.sub_name
  location = "West Europe"
}

module "Networking" {
  source         = "../../Modules/Networking"
  sub_name       = local.sub_name
  resource_group = azurerm_resource_group.example
  address_space  = local.address_space
}
