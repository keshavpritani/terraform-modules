variable "name" {}

variable "want_nat" {
  type     = bool
  default  = false
  nullable = false
}

variable "vpc_id" {
  default  = ""
  nullable = false
}


variable "nat_subnet_id" {
  default  = ""
  nullable = false
}

variable "eip_id" {
  default  = "new"
  nullable = false
}

variable "igw_rt_ids" {
  type     = list(any)
  default  = []
  nullable = false
}

variable "igw_rt_ids_assocation" {
  type     = list(any)
  default  = []
  nullable = false
}

variable "nat_rt_ids" {
  type     = list(any)
  default  = []
  nullable = false
}

variable "is_nat_public" {
  type    = bool
  default = true
}
