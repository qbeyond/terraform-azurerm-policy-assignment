data "azurerm_policy_set_definition" "this" {
  count = local.is_PolicySet ? 1 : 0
  name = replace(var.policy_definition_id, "//.*/", "") #name is last part of id
}

data "azurerm_policy_definition" "this" {
  for_each = toset(local.policy_definition_names)
  name = each.key
}

resource "random_uuid" "name" {
  byte_length = 16
}

resource "azurerm_resource_group_policy_assignment" "this" {
  name                 = coalesce(var.name, var.policy_definition.name, random_id.name.b64_url)
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
  for_each           = toset(azurerm_policy_definition.this.*.role_definition_ids)
  scope              = var.scope
  role_definition_id = each.value
  principal_id       = azurerm_resource_group_policy_assignment.policy.identity[0].principal_id
}
