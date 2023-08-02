variable "name" {
  description = "(Required) Desired name for the route table resources."
  type        = string
  nullable    = false
}

variable "vpc_id" {
  description = "(Required) The ID of the VPC which the route table belongs to."
  type        = string
  nullable    = false
}

variable "subnets" {
  description = "(Optional) A list of subnet IDs to associate with the route table."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "gateways" {
  description = "(Optional) A list of gateway IDs to associate with the route table. Only support Internet Gateway and Virtual Private Gateway."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "vpc_gateway_endpoints" {
  description = "(Optional) A list of the VPC Endpoint IDs with which the Route Table will be associated."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "propagating_vpn_gateways" {
  description = "(Optional) A list of Virtual Private Gateway IDs to propagate routes from."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "is_main" {
  description = "(Optional) Whether to set this route table as the main route table."
  type        = bool
  default     = false
  nullable    = false
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

variable "tags" {
  description = "(Optional) A map of tags to add to all resources."
  type        = map(string)
  default     = {}
  nullable    = false
}

variable "module_tags_enabled" {
  description = "(Optional) Whether to create AWS Resource Tags for the module informations."
  type        = bool
  default     = true
  nullable    = false
}
