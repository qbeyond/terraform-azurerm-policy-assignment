locals {
  parameters = {
    for name, value in var.parameters : name => {
      "value" = value
    }
  }
  is_PolicySet = regexall("/providers/Microsoft.Authorization/policySetDefinitions/",var.policy_definition_id) > 0
  policy_references = local.is_PolicySet ? data.azurerm_policy_set_definition.this.*.policy_definition_reference : []
  policy_definition_ids = local.is_PolicySet ? local.policy_references.*.policy_definition_id : [var.policy_definition_id]
  policy_definition_names = [for id in local.policy_definition_ids : replace(var.policy_definition_id, "//.*/", "")] #name is last part of id
}
