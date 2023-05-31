data "azurerm_policy_set_definition" "this" {
  count = local.is_PolicySet ? 1 : 0
  name = replace(var.policy_definition_id, local.regex_pattern_id_to_name, "") #name is last part of id
}

data "azurerm_policy_definition" "this" {
  for_each = toset(local.policy_definition_names)
  name = each.key
}

resource "random_uuid" "name" {
}

resource "azurerm_resource_group_policy_assignment" "this" {
  name                 = random_uuid.name.result
  policy_definition_id = var.policy_definition_id
  resource_group_id    = var.scope

  display_name = local.display_name
  description  = local.description
  
  location     = var.location

  parameters = local.parameters
  metadata = local.metadata
  identity {
    type = "SystemAssigned"
  }
}

data "azurerm_role_definition" "this" {
  for_each           = toset(local.role_definition_ids)
  role_definition_id = regex("[\\w-]+$", each.key) # we only need the UUID
  scope = var.scope
}


resource "azurerm_role_assignment" "this" {
  for_each = toset(local.role_definition_ids)
  scope              = var.scope
  role_definition_id = data.azurerm_role_definition.this[each.key].id
  principal_id       = azurerm_resource_group_policy_assignment.this.identity[0].principal_id
}
