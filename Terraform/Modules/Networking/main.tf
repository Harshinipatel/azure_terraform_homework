provider "azurerm" {
  features {}
  subscription_id = "d26cddd1-742b-4b36-a651-f260bfd35feb"
  alias           = "Subscription_A"
}

data "azurerm_resource_group" "rg" {
  provider = "azurerm.Subscription_A"
  name     = "Subscription_A"
}

data "azurerm_virtual_network" "vnet1" {
  provider            = "azurerm.Subscription_A"
  name                = "Subscription_A"
  resource_group_name = "Subscription_A"
}

data "azurerm_network_security_group" "example1" {
  provider            = "azurerm.Subscription_A"
  name                = "Sub_A_NSG"
  resource_group_name = "Subscription_A"
}

resource "azurerm_virtual_network" "example" {
  name                = var.sub_name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  address_space       = [var.address_space]
}

resource "azurerm_subnet" "example" {
  name                 = "Subnet_1"
  resource_group_name  = var.resource_group.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = [var.address_space]
}

resource "azurerm_network_security_group" "example" {
  name                = "acceptanceTestSecurityGroup1"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
}

resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.example.id
  network_security_group_id = azurerm_network_security_group.example.id
}

resource "azurerm_network_security_rule" "example" {
  provider                    = "azurerm.Subscription_A"
  name                        = "test1234"
  priority                    = data.azurerm_network_security_group.example1.security_rule[2].priority + 2
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "Subscription_A"
  network_security_group_name = "Sub_A_NSG"
}

resource "azurerm_virtual_network_peering" "subA-subB" {
  provider                     = "azurerm.Subscription_A"
  name                         = "subA-subB"
  resource_group_name          = data.azurerm_resource_group.rg.name
  virtual_network_name         = data.azurerm_virtual_network.vnet1.name
  remote_virtual_network_id    = azurerm_virtual_network.example.id
  allow_virtual_network_access = "true"
  allow_forwarded_traffic      = "true"
}

resource "azurerm_virtual_network_peering" "subB-subA" {
  name                         = "subB-subA"
  resource_group_name          = var.resource_group.name
  virtual_network_name         = azurerm_virtual_network.example.name
  remote_virtual_network_id    = data.azurerm_virtual_network.vnet1.id
  allow_virtual_network_access = "true"
  allow_forwarded_traffic      = "true"
}
