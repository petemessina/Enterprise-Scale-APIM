resource "azurerm_api_management" "apimanagement" {
  name                = var.name
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
