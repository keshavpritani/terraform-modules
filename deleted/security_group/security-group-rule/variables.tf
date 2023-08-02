
variable "sg_id" {
  description = "(Required) The ID of the associated SG."
  type        = string
}

variable "ingress_rules" {
  description = "(Optional) A list of ingress rules in a security group."
  type        = any
  default     = []
}

variable "egress_rules" {
  description = "(Optional) A list of egress rules in a security group."
  type        = any
  default     = []
}
