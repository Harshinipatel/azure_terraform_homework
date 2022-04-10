locals {
  sub_name      = "Subscription_A"
  address_space = "10.0.1.0/24"
}

provider "azurerm" {
  features {}
}

provider "azurerm" {
  features {}
  subscription_id            = "d26cddd1-742b-4b36-a651-f260bfd35feb"
  alias                      = "Subscription_A"
  skip_provider_registration = true
}

resource "azurerm_resource_group" "example" {
  name     = local.sub_name
  location = "West Europe"
}

resource "azurerm_virtual_network" "example" {
  name                = local.sub_name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = [local.address_space]
}

resource "azurerm_subnet" "example" {
  name                 = "Subnet_1"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = [local.address_space]
}

resource "azurerm_network_security_group" "example" {
  name                = "Sub_A_NSG"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.example.id
  network_security_group_id = azurerm_network_security_group.example.id
}

resource "azurerm_network_security_rule" "example1" {
  name                        = "test1"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "10.0.0.0/24"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.example.name
  network_security_group_name = azurerm_network_security_group.example.name
}

resource "azurerm_network_security_rule" "example2" {
  name                        = "test12"
  priority                    = 102
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "10.0.0.0/24"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.example.name
  network_security_group_name = azurerm_network_security_group.example.name
}

resource "azurerm_network_security_rule" "example3" {
  name                        = "test123"
  priority                    = 104
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "10.0.0.0/24"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.example.name
  network_security_group_name = azurerm_network_security_group.example.name
}

output "vnet_id" {
  value = azurerm_virtual_network.example.id
}

output "rg_name" {
  value = azurerm_resource_group.example.name
}

output "vnet_name" {
  value = azurerm_virtual_network.example.name
}

output "last_priority" {
  value = azurerm_network_security_rule.example3.priority
}

data "azurerm_network_security_group" "example" {
  name                = azurerm_network_security_group.example.name
  resource_group_name = azurerm_resource_group.example.name

}
output "nsg_rule" {
  value = data.azurerm_network_security_group.example.security_rule[2].priority
}