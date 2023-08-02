variable "name" {
  description = "Desired name for the VPC Peering resources."
  type        = string
}

variable "requester_vpc_id" {
  description = "The ID of the requester VPC."
  type        = string
}

variable "accepter_vpc_id" {
  description = "The ID of the VPC with which you are creating the VPC Peering Connection."
  type        = string
}

variable "requester_rt_ids" {
  description = "The RouteTable IDs of the requester VPC."
  type        = map(string)
  default     = {}
  nullable    = false
}

variable "accepter_rt_ids" {
  description = "The RouteTable IDs of the VPC with which you are creating the VPC Peering Connection."
  type        = map(string)
  default     = {}
  nullable    = false
}

variable "requester_allow_remote_vpc_dns_resolution" {
  description = "Allow a requester VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the accepter VPC. This is not supported for inter-region VPC peering."
  type        = bool
  default     = false
  nullable    = false
}

variable "accepter_allow_remote_vpc_dns_resolution" {
  description = "Allow a accepter VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the requester VPC. This is not supported for inter-region VPC peering."
  type        = bool
  default     = false
  nullable    = false
}
