variable "name" {
  type        = string
  description = "The name which should be used for this Policy Assignment. Changing this forces a new Resource Policy Assignment to be created."
  default     = null
  nullable    = false
}

variable "display_name" {
  type        = string
  description = "The Display Name for this Policy Assignment."
  default     = null
  nullable    = false
}

variable "description" {
  type        = string
  description = "A description which should be used for this Policy Assignment."
  default     = null
  nullable    = false
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
  type        = map(any)
  description = "Map of Parameters for policy assignment"
  nullable    = false
}

variable "metadata" {
  type        = map(string)
  description = "A Map of any Metadata for this Policy"
}

variable "policy_definition" {
  type = object({
    id          = string
    policy_rule = string
    name        = string
  })
  description = "The policy Definition. Policy Rule is used to calculate the needed role assignments. Name is used as a default for assignment."
  nullable    = false
}
