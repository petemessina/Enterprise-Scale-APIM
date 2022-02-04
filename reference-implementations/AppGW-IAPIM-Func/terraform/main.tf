locals {
  resource_suffix = "001"
  rg_name         = "${var.workload_name}-${var.deployment_environment}-rg"
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
resource "azurerm_resource_group" "hub_rg" {
  name     = local.rg_name
  location = var.location
}

module "keyvault" {
  source = "./keyvault"

  tenant_id               = data.azurerm_client_config.current.tenant_id
  resource_group_name     = azurerm_resource_group.hub_rg.name
  resource_group_location = azurerm_resource_group.hub_rg.location
  workload_name           = var.workload_name
  resource_suffix         = local.resource_suffix
  deployment_environment  = var.deployment_environment
}

module "networking" {
  source = "./networking"

  resource_group_name     = azurerm_resource_group.hub_rg.name
  resource_group_location = azurerm_resource_group.hub_rg.location
  workload_name           = var.workload_name
  deployment_environment  = var.deployment_environment
}

module "apim" {
  source = "./apim"

  resource_group_name     = azurerm_resource_group.hub_rg.name
  resource_group_location = azurerm_resource_group.hub_rg.location
  workload_name           = var.workload_name
  deployment_environment  = var.deployment_environment
  resource_suffix         = local.resource_suffix
}

