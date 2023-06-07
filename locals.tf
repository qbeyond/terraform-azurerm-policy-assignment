locals {
  display_name = try(coalesce(var.display_name, var.policy_set_definition.display_name), null)
  description = try(coalesce(var.description, var.policy_set_definition.description), null)
  parameters = var.parameters == null ? null : jsonencode({
    for name, value in var.parameters : name => {
      "value" = value
    }
  })
  metadata = var.metadata == null ? null : jsonencode(var.metadata)
  
  role_definition_ids = flatten(var.policy_definitions.*.role_definition_ids)

  regex_pattern_id_to_name = "[\\w-]+$"
}
