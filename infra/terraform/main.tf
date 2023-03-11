resource "azurerm_storage_account" "sa" {
  name                     = local.storage_account_name
  resource_group_name      = local.resource_group_name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = local.tags
}

resource "azurerm_service_plan" "fasp" {
  name                = local.service_plan_name
  location            = local.location
  resource_group_name = local.resource_group_name
  os_type             = "Linux"
  sku_name            = "Y1"
  tags                = local.tags
}

resource "azurerm_linux_function_app" "fa" {
  name                       = local.function_app_name
  location                   = local.location
  resource_group_name        = local.resource_group_name
  service_plan_id            = azurerm_service_plan.fasp.id
  storage_account_name       = azurerm_storage_account.sa.name
  storage_account_access_key = azurerm_storage_account.sa.primary_access_key
  site_config {
    application_stack {
      python_version = "3.9"
    }
  }
  tags = local.tags
}
