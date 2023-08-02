variable "create" {
  description = "Whether to create an instance"
  type        = bool
  default     = true
  nullable    = false
}

variable "properties" {
  description = "All the properties, list of objects and values"
  default     = [{}]
  nullable    = false
}

variable "tags" {
  type     = map(any)
  default  = {}
  nullable = false
}
