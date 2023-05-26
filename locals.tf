locals {
  parameters = {
    for name, value in var.parameters : name => {
      "value" = value
    }
  }
  name = var.name == null ? var.policy_definition.name : var.name
}
