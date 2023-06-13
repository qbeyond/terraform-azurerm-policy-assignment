output "resource_group_policy_assignment" {
  value       = azurerm_resource_group_policy_assignment.this
  description = "The `azurerm_resource_group_policy_assignment` object, if scope was a `resource_group`."
  precondition {
    # check if  role_definitions extracted by provider equals the role definitions extracted from policy_rule
    condition     = length(setunion(setsubtract(flatten(var.policy_definitions[*].role_definition_ids), local.role_definition_ids), setsubtract(local.role_definition_ids, flatten(var.policy_definitions[*].role_definition_ids)))) == 0
    error_message = "The needed role definitions to assign from azure and calculated locally aren't the same."
  }
}
