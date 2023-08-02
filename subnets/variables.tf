variable "subnets" {
  type = any
}

variable "tags" {
  type    = map(any)
  default = {}
}
