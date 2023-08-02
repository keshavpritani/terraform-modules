variable "sg_id" {
  type    = string
  default = null
}

variable "ingress_rules" {
  description = "(Optional) A list of ingress rules in a security group."
  type        = any
  default     = {}
  nullable    = false
}

variable "egress_rules" {
  description = "(Optional) A list of egress rules in a security group."
  type        = any
  default     = {}
  nullable    = false
}
