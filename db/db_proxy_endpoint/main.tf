resource "aws_db_proxy_endpoint" "this" {
  for_each = { for k, v in var.db_proxy_endpoints : k => v if var.create_proxy_endpoint }

  db_proxy_name          = var.proxy_name
  db_proxy_endpoint_name = each.value.name
  vpc_subnet_ids         = each.value.vpc_subnet_ids
  vpc_security_group_ids = lookup(each.value, "vpc_security_group_ids", null)
  target_role            = lookup(each.value, "target_role", null)
}