module "vnet" {
  source              = "../../modules/azurerm_vnet"
  vnet_name           = "bps-india-VNet"
  location            = "centralindia"
  resource_group_name = "bps-dev-india-rg"
  address_space       = ["10.70.0.0/16"]
}

module "subnet" {
  depends_on           = [module.vnet]
  source               = "../../modules/azurerm_subnet"
  subnet_name          = "frontend-subnet"
  resource_group_name  = "bps-dev-india-rg"
  virtual_network_name = "bps-india-VNet"
  address_prefixes     = ["10.70.0.0/24"]
}

module "pip" {
  depends_on          = [module.vnet]
  source              = "../../modules/azurerm_pip"
  pip_name            = "frontend-pip"
  resource_group_name = "bps-dev-india-rg"
  location            = "centralindia"
}

module "nic" {
  depends_on            = [module.subnet]
  source                = "../../modules/azurerm_nic"
  nic_name              = "frontend-nic"
  location              = "centralindia"
  resource_group_name   = "bps-dev-india-rg"
  ip_configuration_name = "configuration1"
  subnet_name           = "frontend-subnet"
  virtual_network_name  = "bps-india-VNet"
  publicip_name         = "frontend-pip"
}

module "vm" {
  depends_on          = [module.nic]
  source              = "../../modules/azurerm_vm"
  vm_name             = "frontend-VM"
  resource_group_name = "bps-dev-india-rg"
  location            = "centralindia"
  size                = "Standard_B2s"
  computer_name       = "Ghost"
  os_disk_name        = "Frontend-os-disk"
  publisher           = "Canonical"
  offer               = "0001-com-ubuntu-server-jammy"
  sku                 = "22_04-lts"
  version1            = "latest"
  key_vault_name      = "ket-vault0001"
  username_secret_key = "frontend-vm-username"
  pwd_secret_key      = "frontend-vm-pwd"
  nic_name            = "frontend-nic"
}

module "nsg" {
  source                  = "../../modules/azurerm_nsg"
  nsg_name                = "frontend-network-security-group"
  location                = "centralindia"
  resource_group_name     = "bps-dev-india-rg"
  security_rule_name      = "test123"
  destination_port_ranges = ["22", "80"]
}

module "server" {
    depends_on = [ module.vnet ]
  source                       = "../../modules/azurerm_server"
  server_name                  = "dev-indian-server"
  resource_group_name          = "bps-dev-india-rg"
  location                     = "centralindia"
  key_vault_name               = "ket-vault0001"
  database_username_secret_key = "Database-Username"
  database_pwd_secret_key      = "Database-Pwd"
}

module "database" {
    depends_on = [ module.server ]
  source              = "../../modules/azurerm_database"
  database_name       = "bps-dev-frontend-database"
  server_name         = "dev-indian-server"
  resource_group_name = "bps-dev-india-rg"
}
