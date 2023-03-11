locals {
  location = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  function_app_name = "${var.common_name}-fa"
  service_plan_name = "${var.common_name}-fa-sp"
  storage_account_name = "${var.common_name}fasa"
  copy_function_name = "${var.common_name}-parallel-copy"
  tags = {
    "Owner" = "${var.owner_tag}"
  }
}