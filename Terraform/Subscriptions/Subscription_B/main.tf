locals {
  sub_name      = "Subscription_B"
  address_space = "10.0.2.0/24"
}

provider "azurerm" {
  features {}
}

provider "azurerm" {
  features {}
  subscription_id            = "a1e8bfbe-598d-4d2b-9292-60ad4a19dbd2"
  skip_provider_registration = true
  alias                      = "Subscription_B"
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
