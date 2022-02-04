locals {
    apim_name = substr("apim-${var.workload_name}-${var.deployment_environment}-${var.resource_group_location}-${var.resource_suffix}", 0, 24)
}

resource "azurerm_api_management" "apimanagement" {
  name                = local.apim_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  publisher_name      = "contoso"
  publisher_email     = "test@contoso.com"
  sku_name = "Developer_1"
  virtual_network_type = "None"
  identity {
    type = "SystemAssigned"
  }
  }
