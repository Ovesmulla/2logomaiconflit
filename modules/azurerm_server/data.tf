data "azurerm_key_vault" "key" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
}

data "azurerm_key_vault_secret" "username" {
  name         = var.database_username_secret_key
  key_vault_id = data.azurerm_key_vault.key.id
}

data "azurerm_key_vault_secret" "pwd" {
  name         = var.database_pwd_secret_key
  key_vault_id = data.azurerm_key_vault.key.id
}