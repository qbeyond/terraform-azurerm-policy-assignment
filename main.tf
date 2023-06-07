data "azurerm_policy_set_definition" "this" {
  count = local.is_PolicySet ? 1 : 0
  name  = replace(var.policy_set_definition_id, local.regex_pattern_id_to_name, "") #name is last part of id
}

data "azurerm_policy_definition" "this" {
  count = length(local.policy_definition_ids)
  name  = replace(local.policy_definition_ids[count.index], local.regex_pattern_id_to_name, "")
  lifecycle {
    precondition {
      condition     = !(var.policy_set_definition_id == null && var.policy_definition_id == null)
      error_message = "`policy_set_definition_id` or `policy_definition_id` is required."
    }
    precondition {
      condition     = !(var.policy_set_definition_id != null && var.policy_definition_id != null)
      error_message = "Only `policy_set_definition_id` or `policy_definition_id` is allowed."
    }
  }
}

resource "random_uuid" "name" {
}

resource "azurerm_resource_group_policy_assignment" "this" {
  name                 = random_uuid.name.result
  policy_definition_id = local.is_PolicySet ? var.policy_set_definition_id : var.policy_definition_id
  resource_group_id    = var.scope

  display_name = local.display_name
  description  = local.description

  location = var.location

  parameters = local.parameters
  metadata   = local.metadata
  identity {
    type = "SystemAssigned"
  }
}

data "azurerm_role_definition" "this" {
  count              = length(local.role_definition_ids)
  role_definition_id = replace(local.role_definition_ids[count.index], local.regex_pattern_id_to_name, "")
  scope              = var.scope
}


resource "azurerm_role_assignment" "this" {
  count              = length(local.role_definition_ids)
  scope              = var.scope
  role_definition_id = data.azurerm_role_definition.this[count.index].id
  principal_id       = azurerm_resource_group_policy_assignment.this.identity[0].principal_id
}
