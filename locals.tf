locals {
  parameters = {
    for name, value in var.parameters : name => {
      "value" = value
    }
  }
}
