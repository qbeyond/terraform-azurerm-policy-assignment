# Module
[![GitHub tag](https://img.shields.io/github/tag/qbeyond/terraform-azurerm-policy-assignment.svg)](https://registry.terraform.io/modules/qbeyond/terraform-azurerm-policy-assignment/provider/latest)
[![License](https://img.shields.io/github/license/qbeyond/terraform-azurerm-policy-assignment.svg)](https://github.com/qbeyond/terraform-azurerm-policy-assignment/blob/main/LICENSE)

----

This module streamlines the assignment of policies. You don't need to worry about assigning the correct roles or using the correct resource.

<!-- BEGIN_TF_DOCS -->
## Usage

Currently only assignment of policy and policy set (Initiative) to resource group is supported.
```hcl
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
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=2.66.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | The Azure Region where the Policy Assignment should exist. Changing this forces a new Policy Assignment to be created. | `string` | n/a | yes |
| <a name="input_policy_definition_id"></a> [policy\_definition\_id](#input\_policy\_definition\_id) | The policy Definition id. | `any` | n/a | yes |
| <a name="input_scope"></a> [scope](#input\_scope) | The scope to assign the policy to. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | A description which should be used for this Policy Assignment. If none is provided the Description of the definition is used. | `string` | `null` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | The Display Name for this Policy Assignment. If none is provided the Display Name of the definition is used. | `string` | `null` | no |
| <a name="input_metadata"></a> [metadata](#input\_metadata) | A Map of any Metadata for this Policy assignment. | `map(string)` | `null` | no |
| <a name="input_parameters"></a> [parameters](#input\_parameters) | Map of Parameters for policy assignment | `any` | `null` | no |
## Outputs

No outputs.

## Resource types

| Type | Used |
|------|-------|
| [azurerm_resource_group_policy_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_policy_assignment) | 1 |
| [azurerm_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | 1 |
| [random_uuid](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | 1 |

**`Used` only includes resource blocks.** `for_each` and `count` meta arguments, as well as resource blocks of modules are not considered.

## Modules

No modules.

## Resources by Files

### main.tf

| Name | Type |
|------|------|
| [azurerm_resource_group_policy_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_policy_assignment) | resource |
| [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [random_uuid.name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [azurerm_policy_definition.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/policy_definition) | data source |
| [azurerm_policy_set_definition.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/policy_set_definition) | data source |
<!-- END_TF_DOCS -->

## Contribute

Please use Pull requests to contribute. Run `terraform apply` for every `examples` and `tests`.

When a new Feature or Fix is ready to be released, create a new Github release and adhere to [Semantic Versioning 2.0.0](https://semver.org/lang/de/spec/v2.0.0.html).