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
  #ts:skip=AC_AZURE_0389 Example RGs should not be locked, but immediately destroyed
  name     = "rg-dev-${random_pet.this.id}-01"
  location = "West Europe"
}

resource "azurerm_policy_definition" "this" {
  name         = "pd-policy-does-nothing-${random_pet.this.id}"
  display_name = "A policy that is just used to test a policy assignment."
  policy_type  = "Custom"
  mode         = "Indexed"
  policy_rule = jsonencode({
    if = {
      field  = "type"
      equals = "qbeyond.Nothing"
    }
    then = {
      effect = "audit"
    }
  })
}

resource "azurerm_policy_set_definition" "this" {
  name         = "pd-policy-set-does-nothing-${random_pet.this.id}"
  display_name = "A policy set that is just used to test a policy assignment."
  policy_type  = "Custom"

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.this.id
    parameter_values     = jsonencode({})
  }
}

module "policy_assignment_resource_group" {
  source                = "../.."
  scope                 = azurerm_resource_group.this.id
  location              = azurerm_resource_group.this.location
  policy_set_definition = azurerm_policy_set_definition.this
  policy_definitions    = [azurerm_policy_definition.this]
}
