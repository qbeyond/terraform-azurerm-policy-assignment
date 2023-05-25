variable "name" {
  type        = string
  description = "The name which should be used for this Policy Assignment. Changing this forces a new Resource Policy Assignment to be created."
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
  })
  description = "The policy Definition Object to use. Needed properties are id and policy_rule"
  nullable    = false
}
