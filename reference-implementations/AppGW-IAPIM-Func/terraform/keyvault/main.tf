resource "azurerm_key_vault" "key_vault" {
  name                        = var.name
  location                    = var.resource_group_location
  resource_group_name         = var.resource_group_name
  tenant_id                   = var.tenant_id
  sku_name                    = "standard"

  access_policy {
    tenant_id = var.tenant_id
    object_id = var.object_id

    secret_permissions = [
      "get",
      "list",
      "set",
      "delete",
      "purge",
      "recover"
    ]
    certificate_permissions = [
      "import",
      "get",
      "list",
      "update",
      "create",
      "delete",
      "purge"
    ]
  }
}