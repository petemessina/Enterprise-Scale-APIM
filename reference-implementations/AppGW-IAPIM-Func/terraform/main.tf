locals {
  rg_name                 = "${var.workload_name}-${var.deployment_environment}-rg"
  app_gateway_name        = "appgw-${module.resource_suffix.name}"
  api_managment_name      = substr("apim-${module.resource_suffix.name}", 0, 24)
  key_vault_name          = substr("kv-${module.resource_suffix.name}", 0, 24)
  primary_backendend_fqdn = "${local.api_managment_name}.azure-api.net"
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.95.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {
}

module "resource_suffix" {
  source = "./modules/service-suffix"

  workload_name           = var.workload_name
  deployment_environment  = var.deployment_environment
  location                = azurerm_resource_group.hub_rg.location
  resource_suffix         = var.resource_suffix
}

resource "azurerm_resource_group" "hub_rg" {
  name     = local.rg_name
  location = var.location
}

module "keyvault" {
  source = "./keyvault"

  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = data.azurerm_client_config.current.object_id
  resource_group_name     = azurerm_resource_group.hub_rg.name
  resource_group_location = azurerm_resource_group.hub_rg.location
  name                    = local.key_vault_name
}

module "networking" {
  source = "./networking"

  resource_group_name     = azurerm_resource_group.hub_rg.name
  resource_group_location = azurerm_resource_group.hub_rg.location
  workload_name           = var.workload_name
  deployment_environment  = var.deployment_environment
}

module "application_gateway" {
  source = "./gateway"

  resource_group_name       = azurerm_resource_group.hub_rg.name
  resource_group_location   = azurerm_resource_group.hub_rg.location
  secret_name               = var.certificate_secret_name
  keyvault_id               = module.keyvault.key_vault_id
  certificate_path          = var.certificate_path
  certificate_password      = var.certificate_password
  name                      = local.app_gateway_name
  fqdn                      = var.app_gateway_fqdn
  primary_backendend_fqdn   = local.primary_backendend_fqdn
  subnet_id                 = module.networking.appgateway_subnet_id
}

module "apim" {
  source = "./apim"

  resource_group_name     = azurerm_resource_group.hub_rg.name
  resource_group_location = azurerm_resource_group.hub_rg.location
  name                    = local.api_managment_name
}

