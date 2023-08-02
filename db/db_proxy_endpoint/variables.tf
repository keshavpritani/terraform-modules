variable "create_proxy_endpoint" {
  description = "Determines whether a proxy endpoint will be created"
  type        = bool
  default     = true
  nullable    = false
}

variable "proxy_name" {
  description = "The identifier for the proxy. This name must be unique for all proxies owned by your AWS account in the specified AWS Region. An identifier must begin with a letter and must contain only ASCII letters, digits, and hyphens; it can't end with a hyphen or contain two consecutive hyphens"
  type        = string
  default     = ""
  nullable    = false
}

# Proxy endpoints
variable "db_proxy_endpoints" {
  description = "Map of DB proxy endpoints to create and their attributes (see `aws_db_proxy_endpoint`)"
  type        = any
  default     = {}
  nullable    = false
}
