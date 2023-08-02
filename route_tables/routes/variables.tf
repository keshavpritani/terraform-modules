variable "route_table_id" {
  description = "(Required) Route Table Id."
  type        = string
}

variable "ipv4_routes" {
  description = "(Optional) A list of route rules for IPv4 CIDRs."
  type        = list(map(string))
  default     = []
  nullable    = false
}

variable "ipv6_routes" {
  description = "(Optional) A list of route rules for IPv6 CIDRs."
  type        = list(map(string))
  default     = []
  nullable    = false
}

variable "prefix_list_routes" {
  description = "(Optional) A list of route rules for Managed Prefix List."
  type        = list(map(string))
  default     = []
  nullable    = false
}
