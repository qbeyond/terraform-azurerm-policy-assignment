provider "azurerm" {
  features {
  }
}

resource "random_pet" "this" {
  separator = ""
  length = 1
  prefix = "PolicyAssignment"
}

resource "azurerm_resource_group" "this" {
  name     = "rg-dev-${random_pet.this.id}-01"
  location = "West Europe"
}

data "azurerm_policy_definition" "this" {
  display_name = "Not allowed resource types"
}
module "policy_assignment_resource_group" {
  source = "../.."
  scope = azurerm_resource_group.this.id
  location = azurerm_resource_group.this.location
  policy_definition_id = data.azurerm_policy_definition.this.id
  parameters = {
    listOfResourceTypesNotAllowed = []
  }
}
