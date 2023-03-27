# input data lake
resource "azurerm_storage_account" "dl_input" {
  name                     = local.input_datalake_name
  resource_group_name      = local.resource_group_name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = "true"
  tags                     = local.tags
}

resource "azurerm_storage_data_lake_gen2_filesystem" "dlfs_input" {
  name               = local.input_datalake_file_system
  storage_account_id = azurerm_storage_account.dl_input.id
}

# output data lake
resource "azurerm_storage_account" "dl_output" {
  name                     = local.output_datalake_name
  resource_group_name      = local.resource_group_name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = "true"
  tags                     = local.tags
}

resource "azurerm_storage_data_lake_gen2_filesystem" "dlfs_output" {
  name               = local.input_datalake_file_system
  storage_account_id = azurerm_storage_account.dl_output.id
}

# function
resource "azurerm_storage_account" "sa" {
  name                     = local.storage_account_name
  resource_group_name      = local.resource_group_name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = local.tags
}

resource "azurerm_application_insights" "appins" {
  name                = local.application_insights_name
  location            = local.location
  resource_group_name = local.resource_group_name
  application_type    = "web"
  tags                = local.tags
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
  app_settings = {
    input_dl_key = azurerm_storage_account.dl_input.primary_access_key
    input_dl_name = azurerm_storage_account.dl_input.name
    input_dlfs_name = azurerm_storage_data_lake_gen2_filesystem.dlfs_input.name
    output_dl_key = azurerm_storage_account.dl_output.primary_access_key
    output_dl_name = azurerm_storage_account.dl_output.name
    output_dlfs_name = azurerm_storage_data_lake_gen2_filesystem.dlfs_output.name
  }
  site_config {
    application_stack {
      python_version = "3.9"
    }
    application_insights_key = "${azurerm_application_insights.appins.instrumentation_key}"
  }
  tags = local.tags
  lifecycle {
    ignore_changes = [
      tags["hidden-link: /app-insights-instrumentation-key"],
      tags["hidden-link: /app-insights-resource-id"]
    ]
  }
}

resource "null_resource" "deploy_to_fa" {    
  triggers = {
    app_code = sha1(join("", [for f in fileset(local.app_code_location_for_terraform, "**"): filesha1("${local.app_code_location_for_terraform}\\${f}")]))
    deploy_cmd = local.fa_deploy_cmd
  }
  provisioner "local-exec" {
    command = local.fa_deploy_cmd
    working_dir = local.cmd_work_dir
  }
  depends_on = [
    azurerm_linux_function_app.fa
  ]
}

