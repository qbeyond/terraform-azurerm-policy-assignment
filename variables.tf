variable "policy_set_definition" {
  description = "The policy set deifnition to assign."
  type = object({
    id                          = string
    policy_definition_reference = list(object({ policy_definition_id = string }))
    display_name                = optional(string)
    description                 = optional(string)
  })
}

variable "policy_definitions" {
  description = "The policy definitions, that are referenced by the policy set. `id` is used to validate, that every referenced policy is present. `policy_rule` is used to extract ids of role definitions required for remediation. `role_definition_id` is used to validate the role_assignment."
  type = list(object({
    id                  = string
    policy_rule         = string
    role_definition_ids = list(string)
  }))
}

variable "display_name" {
  type        = string
  description = "The Display Name for this Policy Assignment. If none is provided the Display Name of the definition is used."
  default     = null
}

variable "description" {
  type        = string
  description = "A description which should be used for this Policy Assignment. If none is provided the Description of the definition is used."
  default     = null
}

variable "scope" {
  type        = string
  description = "The scope to assign the policy to."
  nullable    = false
  validation {
    condition     = length(regexall("^/subscriptions/[\\w-]+/resourceGroups/[\\w-]+$", var.scope)) > 0
    error_message = "Only assignment to resource group is supported at the moment."
  }
}

variable "location" {
  type        = string
  description = "The Azure Region where the Policy Assignment should exist. Changing this forces a new Policy Assignment to be created."
  nullable    = false
}

variable "parameters" {
  type        = any
  description = "Map of Parameters for policy assignment."
  default     = null
  validation {
    condition     = var.parameters == null ? true : length(keys(var.parameters)) > 0
    error_message = "Parameters should be a map of values to assign to the parameters."
  }
}

variable "metadata" {
  type        = map(string)
  description = "A Map of any Metadata for this Policy assignment."
  default     = null
}
