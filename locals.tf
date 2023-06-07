locals {
  # either the policy_set_definition or policy_definition, depending on what to assign
  policy_definition = try(data.azurerm_policy_set_definition.this[0], data.azurerm_policy_definition.this[0])
  display_name = try(coalesce(var.display_name, local.policy_definition.display_name), null)
  description = try(coalesce(var.description, local.policy_definition.description), null)
  parameters = var.parameters == null ? null : jsonencode({
    for name, value in var.parameters : name => {
      "value" = value
    }
  })
  metadata = var.metadata == null ? null : jsonencode(var.metadata)
  is_PolicySet = var.policy_definition_id == null
  policy_definition_ids = local.is_PolicySet ? data.azurerm_policy_set_definition.this[0].policy_definition_reference.*.policy_definition_id : [var.policy_definition_id]
  role_definition_ids = flatten([for definition in data.azurerm_policy_definition.this : definition.role_definition_ids])

  regex_pattern_id_to_name = "//.*//"
}
