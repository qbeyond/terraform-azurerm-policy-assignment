# Module
[![GitHub tag](https://img.shields.io/github/tag/qbeyond/terraform-azurerm-policy-assignment.svg)](https://registry.terraform.io/modules/qbeyond/terraform-azurerm-policy-assignment/provider/latest)
[![License](https://img.shields.io/github/license/qbeyond/terraform-azurerm-policy-assignment.svg)](https://github.com/qbeyond/terraform-azurerm-policy-assignment/blob/main/LICENSE)

----

This module streamlines the assignment of policy sets. You don't need to worry about assigning the correct roles, because the needed roles are calculated based on the referenced policies. **Currently only assignment to resource group is supported.**

A `random_uuid` is used as the `name` of the assignment.

<!-- BEGIN_TF_DOCS -->
## Usage

To avoid to rely on data that is only available after apply, you need to provide the `policy_set_definition` and `policy_definitions` that are referenced.

### Custom policy set

You can easily assign a custom policy set to a resource group.

```hcl
provider "azurerm" {
  features {
  }
}

resource "random_pet" "this" {
  separator = ""
  length    = 1
  prefix    = "PolicyAssignment"
}

resource "azurerm_resource_group" "this" {
  #ts:skip=reme_resourceGroupLock Example RGs should not be locked, but immediately destroyed
  name     = "rg-dev-${random_pet.this.id}-01"
  location = "West Europe"
}

resource "azurerm_policy_definition" "this" {
  name         = "pd-policy-does-nothing-${random_pet.this.id}"
  display_name = "A policy that is just used to test a policy assignment."
  policy_type  = "Custom"
  mode         = "Indexed"
  policy_rule = jsonencode({
    if = {
      field  = "type"
      equals = "qbeyond.Nothing"
    }
    then = {
      effect = "audit"
    }
  })
}

resource "azurerm_policy_set_definition" "this" {
  name         = "pd-policyset-does-nothing-${random_pet.this.id}"
  display_name = "A policy set that is just used to test a policy assignment."
  policy_type  = "Custom"

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.this.id
    parameter_values     = jsonencode({})
  }
}

module "policy_assignment_resource_group" {
  source                = "../.."
  scope                 = azurerm_resource_group.this.id
  location              = azurerm_resource_group.this.location
  policy_set_definition = azurerm_policy_set_definition.this
  policy_definitions    = [azurerm_policy_definition.this]
}
```

### Built In policy set

To assign a built in policy set, you need to retrieve the set and referenced policies as data sources and pass them to the module.

```hcl
provider "azurerm" {
  features {
  }
}

resource "random_pet" "this" {
  separator = ""
  length    = 1
  prefix    = "PolicyAssignment"
}

resource "azurerm_resource_group" "this" {
  #ts:skip=reme_resourceGroupLock Example RGs should not be locked, but immediately destroyed
  name     = "rg-dev-${random_pet.this.id}-01"
  location = "West Europe"
}

resource "azurerm_policy_definition" "this" {
  name         = "pd-policy-does-nothing-${random_pet.this.id}"
  display_name = "A policy that is just used to test a policy assignment."
  policy_type  = "Custom"
  mode         = "Indexed"
  policy_rule = jsonencode({
    if = {
      field  = "type"
      equals = "qbeyond.Nothing"
    }
    then = {
      effect = "audit"
    }
  })
}

resource "azurerm_policy_set_definition" "this" {
  name         = "pd-policyset-does-nothing-${random_pet.this.id}"
  display_name = "A policy set that is just used to test a policy assignment."
  policy_type  = "Custom"

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.this.id
    parameter_values     = jsonencode({})
  }
}

module "policy_assignment_resource_group" {
  source                = "../.."
  scope                 = azurerm_resource_group.this.id
  location              = azurerm_resource_group.this.location
  policy_set_definition = azurerm_policy_set_definition.this
  policy_definitions    = [azurerm_policy_definition.this]
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
| <a name="input_policy_definitions"></a> [policy\_definitions](#input\_policy\_definitions) | The policy definitions, that are referenced by the policy set. `id` is used to validate, that every referenced policy is present. `policy_rule` is used to extract ids of role definitions required for remediation. `role_definition_id` is used to validate the role\_assignment. | <pre>list(object({<br>    id                  = string<br>    policy_rule         = string<br>    role_definition_ids = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_policy_set_definition"></a> [policy\_set\_definition](#input\_policy\_set\_definition) | The policy set deifnition to assign. | <pre>object({<br>    id                          = string<br>    policy_definition_reference = list(object({ policy_definition_id = string }))<br>    display_name                = optional(string)<br>    description                 = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_scope"></a> [scope](#input\_scope) | The scope to assign the policy to. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | A description which should be used for this Policy Assignment. If none is provided the Description of the definition is used. | `string` | `null` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | The Display Name for this Policy Assignment. If none is provided the Display Name of the definition is used. | `string` | `null` | no |
| <a name="input_metadata"></a> [metadata](#input\_metadata) | A Map of any Metadata for this Policy assignment. | `map(string)` | `null` | no |
| <a name="input_parameters"></a> [parameters](#input\_parameters) | Map of Parameters for policy assignment. | `any` | `null` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_resource_group_policy_assignment"></a> [resource\_group\_policy\_assignment](#output\_resource\_group\_policy\_assignment) | The `azurerm_resource_group_policy_assignment` object, if scope was a `resource_group`. |

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
| [azurerm_role_definition.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/role_definition) | data source |
<!-- END_TF_DOCS -->

## Contribute

Please use Pull requests to contribute. 

Run `terraform apply` for any `examples` and `tests` twice. The second apply shouldn't plan any changes.

When a new Feature or Fix is ready to be released, create a new Github release and adhere to [Semantic Versioning 2.0.0](https://semver.org/lang/de/spec/v2.0.0.html).