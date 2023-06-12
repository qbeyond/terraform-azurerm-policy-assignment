locals {
  name         = coalesce(var.name, random_id.name.hex)
  display_name = try(coalesce(var.display_name, var.policy_set_definition.display_name), null)
  description  = try(coalesce(var.description, var.policy_set_definition.description), null)
  parameters = var.parameters == null ? null : jsonencode({
    for name, value in var.parameters : name => {
      "value" = value
    }
  })
  metadata = var.metadata == null ? null : jsonencode(var.metadata)

  # extract the role_ids from policy_rules, because the property role_ids is only available after apply
  role_definition_ids = distinct(flatten([for definition in var.policy_definitions : try(jsondecode(definition.policy_rule).then.details.roleDefinitionIds, [])]))

  regex_pattern_id_to_name = "[\\w-]+$"
}
