variable "policy_definition_id" {
  description = "The policy Definition id."
  nullable    = false
  validation {
    condition = length(regexall("/providers/Microsoft.Authorization/policy(Set)?Definitions/",var.policy_definition_id)) > 0
    error_message = "Provide valid id for Policy or PolicySet Definition"
  }
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
  description = "Map of Parameters for policy assignment"
  default = null
  validation {
    condition = var.parameters == null ? true : length(keys(var.parameters)) > 0
    error_message = "Parameters should be a map of values to assign to the parameters."
  }
}

variable "metadata" {
  type        = map(string)
  description = "A Map of any Metadata for this Policy assignment."
  default = null
}