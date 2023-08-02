variable "sgs" {
  type     = any
  nullable = false
}

variable "vpc_id" {
  description = "The ID of the associated VPC."
  type        = string
}
