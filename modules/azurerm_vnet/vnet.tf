resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = var.address_space
}

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}