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
  # ts:skip=AC_AZURE_0389 Examples should not be locked, but immediately destroyed
  name     = "rg-dev-${random_pet.this.id}-01"
  location = "West Europe"
}

data "azurerm_policy_set_definition" "this" {
  display_name = "Deploy prerequisites to enable Guest Configuration policies on virtual machines"
}

data "azurerm_policy_definition" "this" {
  for_each = toset(data.azurerm_policy_set_definition.this.policy_definition_reference[*].policy_definition_id)
  name     = regex("[\\w-]+$", each.key)
}

module "policy_assignment_resource_group" {
  source                = "../.."
  scope                 = azurerm_resource_group.this.id
  location              = azurerm_resource_group.this.location
  policy_set_definition = data.azurerm_policy_set_definition.this
  policy_definitions    = [for key, definition in data.azurerm_policy_definition.this : definition]
}
