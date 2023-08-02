module "route_table" {
  source      = "./route-table"
  for_each    = var.route_tables
  vpc_id      = each.value["vpc_id"]
  name        = each.value["name"]
  is_main     = try(each.value["is_main"], null)
  subnets     = try(each.value["subnets"], null)
  ipv4_routes = try(each.value["ipv4_routes"], null)
}
