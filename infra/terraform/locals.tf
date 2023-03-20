locals {
  location = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  application_insights_name = "${var.common_name}-ai"
  function_app_name = "${var.common_name}-fa"
  service_plan_name = "${var.common_name}-fa-sp"
  storage_account_name = "${var.common_name}fasa"
  copy_function_name = "${var.common_name}-parallel-copy"
  tags = {
    "Owner" = "${var.owner_tag}"
  }
  app_code_location_for_terraform = "..\\..\\app\\parallel_copy"
  fa_deploy_cmd = "func azure functionapp publish michalscopytest-fa"
  cmd_work_dir = "..\\..\\app\\parallel_copy"
}