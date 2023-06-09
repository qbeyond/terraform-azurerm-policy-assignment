resource "random_uuid" "name" {
}

resource "azurerm_resource_group_policy_assignment" "this" {
  name                 = random_uuid.name.result
  policy_definition_id = var.policy_set_definition.id
  resource_group_id    = var.scope

  display_name = local.display_name
  description  = local.description

  location = var.location

  parameters = local.parameters
  metadata   = local.metadata
  identity {
    type = "SystemAssigned"
  }
  lifecycle {
    precondition {
      # Check if var.policy_definitions.*.id equals var.policy_set_definition.policy_definition_reference.*.policy_definition_id
      condition     = length(setunion(setsubtract(var.policy_definitions.*.id, var.policy_set_definition.policy_definition_reference.*.policy_definition_id), setsubtract(var.policy_set_definition.policy_definition_reference.*.policy_definition_id, var.policy_definitions.*.id))) == 0
      error_message = "The provided `id`s of `policy_definitions` must equal the referenced policies."
    }
  }
}

# Data source is needed, to generate role id for specific scope, to avoid changes outside of terraform
data "azurerm_role_definition" "this" {
  for_each           = toset(local.role_definition_ids)
  role_definition_id = regex(local.regex_pattern_id_to_name, each.key)
  scope              = var.scope
}


resource "azurerm_role_assignment" "this" {
  for_each           = data.azurerm_role_definition.this
  scope              = var.scope
  role_definition_id = each.value.id
  principal_id       = azurerm_resource_group_policy_assignment.this.identity[0].principal_id
}
