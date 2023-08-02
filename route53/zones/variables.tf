variable "create" {
  description = "Whether to create Route53 zone"
  type        = bool
  default     = true
  nullable    = false
}

variable "zones" {
  description = "Map of Route53 zone parameters"
  type        = any
  default     = {}
  nullable    = false
}

variable "tags" {
  description = "Tags added to all zones. Will take precedence over tags from the 'zones' variable"
  type        = map(any)
  default     = {}
  nullable    = false
}
