provider "azurerm" {
  features {
  }
}

resource "random_pet" "this" {
  separator = ""
  length    = 1
  prefix    = "PolicyAssignment"
}

resource "azurerm_resource_group" "this" {
  #ts:skip=reme_resourceGroupLock Tests RGs should not be locked, but immediately destroyed
  name     = "rg-dev-${random_pet.this.id}-01"
  location = "West Europe"
}

locals {
  policy_sets = {
    DeployIfNotExists_without_parameters = {
      display_name = "Deploy prerequisites to enable Guest Configuration policies on virtual machines"
      parameters   = null
    }
    audit_with_parameters = {
      display_name = "Ensures resources to not have a specifc tag."
      parameters = {
        tagName = "SomeTagName"
      }
    }
  }
  policy_definitions_for_sets = { for key, policy_set in local.policy_sets : key => [for policy_id in data.azurerm_policy_set_definition.this[key].policy_definition_reference[*].policy_definition_id : data.azurerm_policy_definition.this[policy_id]] }
}

data "azurerm_policy_set_definition" "this" {
  for_each     = local.policy_sets
  display_name = each.value.display_name
}

data "azurerm_policy_definition" "this" {
  for_each = toset(flatten([for policy_set in data.azurerm_policy_set_definition.this : policy_set.policy_definition_reference[*].policy_definition_id]))
  name     = regex("[\\w-]+$", each.value)
}

module "policy_set_assignment_resource_group" {
  source                = "./.."
  for_each              = local.policy_sets
  scope                 = azurerm_resource_group.this.id
  location              = azurerm_resource_group.this.location
  policy_set_definition = data.azurerm_policy_set_definition.this[each.key]
  policy_definitions    = local.policy_definitions_for_sets[each.key]
  parameters            = each.value.parameters
}
