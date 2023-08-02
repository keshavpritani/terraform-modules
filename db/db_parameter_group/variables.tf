variable "create" {
  description = "Whether to create this resource or not?"
  type        = bool
  default     = true
  nullable    = false
}

variable "cluster" {
  description = "Whether to create cluster parameter group or not?"
  type        = bool
  default     = false
  nullable    = false
}

variable "name" {
  description = "The name of the DB parameter group"
  type        = string
  default     = ""
  nullable    = false
}

variable "use_name_prefix" {
  description = "Determines whether to use `name` as is or create a unique name beginning with `name` as the specified prefix"
  type        = bool
  default     = false
  nullable    = false
}

variable "description" {
  description = "The description of the DB parameter group"
  type        = string
  default     = null
}

variable "family" {
  description = "The family of the DB parameter group"
  type        = string
  default     = null
}

variable "parameters" {
  description = "A list of DB parameter maps to apply"
  type        = list(map(string))
  default     = []
  nullable    = false
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
  nullable    = false
}
