resource "random_id" "default_values_from_definition" {
  byte_length = 8
}

resource "azurerm_policy_definition" "with_display_name_description" {
  name         = "pd-policy-does-nothing-${random_id.default_values_from_definition.id}"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "azurerm_policy_definition"
  description  = "azurerm_policy_definition"
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

resource "azurerm_policy_set_definition" "with_display_name_description" {
  name         = "pd-policy-set-does-nothing-${random_id.default_values_from_definition.id}"
  policy_type  = "Custom"
  display_name = "azurerm_policy_set_definition"
  description  = "azurerm_policy_set_definition"

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.with_display_name_description.id
    parameter_values     = jsonencode({})
  }
}

module "policy_assignment_with_display_name_description" {
  source                = "./.."
  scope                 = azurerm_resource_group.this.id
  location              = azurerm_resource_group.this.location
  policy_set_definition = azurerm_policy_set_definition.with_display_name_description
  policy_definitions    = [azurerm_policy_definition.with_display_name_description]
}

# Data source is used to validate the module
# tflint-ignore: terraform_unused_declarations
data "azurerm_policy_assignment" "with_display_name_description" {
  name     = module.policy_assignment_with_display_name_description.resource_group_policy_assignment.name
  scope_id = azurerm_resource_group.this.id
  lifecycle {
    # The display_name should be taken from the policy_set
    postcondition {
      condition     = self.display_name == azurerm_policy_set_definition.with_display_name_description.display_name
      error_message = "The module should use the display_name of the policy_set if none is provided."
    }
    # The description should be taken from the policy_set
    postcondition {
      condition     = self.description == azurerm_policy_set_definition.with_display_name_description.description
      error_message = "The module should use the description of the policy_set if none is provided."
    }
  }
}
