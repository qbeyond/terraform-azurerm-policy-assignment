provider "azurerm" {
  features {
  }
}

resource "random_pet" "this" {
  separator = ""
  length = 1
  prefix = "PolicyAssignment"
}

resource "azurerm_resource_group" "this" {
  name     = "rg-dev-${random_pet.this.id}-01"
  location = "West Europe"
}

locals {
  policies = {
    audit_without_parameters = {
      display_name = "Audit usage of custom RBAC roles"
      parameters = null
    }
    autit_with_parameters = {
      display_name = "Not allowed resource types"
      parameters = {
        listOfResourceTypesNotAllowed = []
      }
    }
    DeployIfNotExists_without_parameters = {
      # Should deploy one role assignment
      display_name = "Configure Windows Arc-enabled machines to run Azure Monitor Agent"
      parameters = null
    }
  }
  policy_sets = {
    DeployIfNotExists_without_parameters = {
      display_name = "Deploy prerequisites to enable Guest Configuration policies on virtual machines"
      parameters = null
    }
    audit_with_parameters = {
      display_name = "Ensures resources to not have a specifc tag."
      parameters = {
        tagName = "SomeTagName"
      }
    }
  }
}

data "azurerm_policy_definition" "this" {
  for_each = local.policies
  display_name = each.value.display_name
}
module "policy_assignment_resource_group" {
  for_each = local.policies
  source = "./.."
  scope = azurerm_resource_group.this.id
  location = azurerm_resource_group.this.location
  policy_definition_id = data.azurerm_policy_definition.this[each.key].id
  parameters = each.value.parameters
}

data "azurerm_policy_set_definition" "this" {
  for_each = local.policy_sets
  display_name = each.value.display_name
}

module "policy_set_assignment_resource_group" {
  source = "./.."
  for_each = local.policy_sets
  scope = azurerm_resource_group.this.id
  location = azurerm_resource_group.this.location
  policy_set_definition_id = data.azurerm_policy_set_definition.this[each.key].id
  parameters = each.value.parameters

  
}
