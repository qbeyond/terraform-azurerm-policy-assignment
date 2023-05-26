data "azurerm_policy_definition" "this" {
  id = var.policy_definition.id
}

resource "azurerm_resource_group_policy_assignment" "this" {
  name                 = local.name
  policy_definition_id = var.policy_definition.id
  resource_group_id    = var.scope

  description  = var.description
  display_name = var.display_name
  location     = var.location

  parameters = jsonencode(local.parameters)
  identity {
    type = "SystemAssigned"
  }
}

data "azurerm_role_definition" "this" {
  for_each           = toset(jsondecode(var.policy_definition.policy_rule).then.details.roleDefinitionIds)
  role_definition_id = regex("[\\w-]+$", each.key)
  scope              = var.scope
}

resource "azurerm_role_assignment" "this" {
  for_each           = data.azurerm_role_definition.policy
  scope              = azurerm_policy_assignment.policy.scope
  role_definition_id = each.value.id
  principal_id       = azurerm_policy_assignment.policy.identity[0].principal_id
}
