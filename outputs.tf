output "resource_group_policy_assignment" {
  value = azurerm_resource_group_policy_assignment.this
  description = "The `azurerm_resource_group_policy_assignment` object, if scope was a `resource_group`."
    precondition {
      condition = flatten(var.policy_definitions.*.role_definition_ids) == local.role_definition_ids
      error_message = "The needed role definitions to assign from azure and calculated locally aren't the same."
    }
}