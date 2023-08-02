variable "create" {
  description = "Whether to create DNS records"
  type        = bool
  default     = true
  nullable    = false
}

variable "zone_id" {
  description = "ID of DNS zone"
  type        = string
  default     = null
}

variable "records" {
  description = "List of objects of DNS records"
  type        = any
  default     = []
  nullable    = false
}

variable "records_jsonencoded" {
  description = "List of map of DNS records (stored as jsonencoded string, for terragrunt)"
  type        = string
  default     = null
}
