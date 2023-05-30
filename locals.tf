locals {
  # either the policy_set_definition or policy_definition, depending on what to assign
  policy_definition = merge(try(data.azurerm_policy_set_definition.this[0], {}),try(data.azurerm_policy_definition.this[one(keys(data.azurerm_policy_definition.this))], {}))
  display_name = try(coalesce(var.display_name, local.policy_definition.display_name), null)
  description = try(coalesce(var.description, local.policy_definition.description), null)
  parameters = var.parameters == null ? null : jsonencode({
    for name, value in var.parameters : name => {
      "value" = value
    }
  })
  metadata = var.metadata == null ? null : jsonencode(var.metadata)
  is_PolicySet = length(regexall("/providers/Microsoft.Authorization/policySetDefinitions/",var.policy_definition_id)) > 0
  policy_definition_ids = local.is_PolicySet ? data.azurerm_policy_set_definition.this[0].policy_definition_reference.*.policy_definition_id : [var.policy_definition_id]
  policy_definition_names = [for id in local.policy_definition_ids : replace(id, "//.*//", "")] #name is last part of id
  role_definition_ids = flatten([for definition in data.azurerm_policy_definition.this : definition.role_definition_ids])
}
