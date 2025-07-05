data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.resource_group_name
}

data "azurerm_public_ip" "puplicip" {
  name                = var.publicip_name
  resource_group_name = var.resource_group_name
}