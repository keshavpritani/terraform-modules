# DB proxy endponts
output "db_proxy_endpoints" {
  description = "Array containing the full resource object and attributes for all DB proxy endpoints created"
  value       = aws_db_proxy_endpoint.this
}

output "proxy_endpoint" {
  description = "The endpoint that you can use to connect to the proxy"
  value       = { for k, v in aws_db_proxy_endpoint.this : k => v.endpoint }
}
