variable "name" {
  description = "Desired name for the network ACL resources."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the associated VPC."
  type        = string
}

variable "subnets" {
  description = "A list of subnet IDs to apply the ACL to."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "ingress_rules" {
  description = "A map of ingress rules in a network ACL. Use the key of map as the rule number."
  type        = map(map(any))
  default     = {}
  nullable    = false
}

variable "egress_rules" {
  description = "A map of egress rules in a network ACL. Use the key of map as the rule number."
  type        = map(map(any))
  default     = {}
  nullable    = false
}