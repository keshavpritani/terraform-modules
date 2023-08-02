###################################################
# Routes
###################################################

# INFO: Not supported attributes
# - `instance_id` (Deprecated)
resource "aws_route" "ipv4" {
  for_each = {
    for route in var.ipv4_routes :
    route.cidr_block => route
  }

  route_table_id         = var.route_table_id
  destination_cidr_block = each.key

  carrier_gateway_id        = try(each.value.carrier_gateway_id, null)
  core_network_arn          = try(each.value.core_network_arn, null)
  egress_only_gateway_id    = try(each.value.egress_only_gateway_id, null)
  gateway_id                = try(each.value.gateway_id, null)
  local_gateway_id          = try(each.value.local_gateway_id, null)
  nat_gateway_id            = try(each.value.nat_gateway_id, null)
  network_interface_id      = try(each.value.network_interface_id, null)
  transit_gateway_id        = try(each.value.transit_gateway_id, null)
  vpc_endpoint_id           = try(each.value.vpc_endpoint_id, null)
  vpc_peering_connection_id = try(each.value.vpc_peering_connection_id, null)
}

resource "aws_route" "ipv6" {
  for_each = {
    for route in var.ipv6_routes :
    route.cidr => route
  }

  route_table_id              = var.route_table_id
  destination_ipv6_cidr_block = each.key

  carrier_gateway_id        = try(each.value.carrier_gateway_id, null)
  core_network_arn          = try(each.value.core_network_arn, null)
  egress_only_gateway_id    = try(each.value.egress_only_gateway_id, null)
  gateway_id                = try(each.value.gateway_id, null)
  local_gateway_id          = try(each.value.local_gateway_id, null)
  nat_gateway_id            = try(each.value.nat_gateway_id, null)
  network_interface_id      = try(each.value.network_interface_id, null)
  transit_gateway_id        = try(each.value.transit_gateway_id, null)
  vpc_endpoint_id           = try(each.value.vpc_endpoint_id, null)
  vpc_peering_connection_id = try(each.value.vpc_peering_connection_id, null)
}

resource "aws_route" "prefix_list" {
  for_each = {
    for route in var.prefix_list_routes :
    route.id => route
  }

  route_table_id             = var.route_table_id
  destination_prefix_list_id = each.key

  carrier_gateway_id        = try(each.value.carrier_gateway_id, null)
  core_network_arn          = try(each.value.core_network_arn, null)
  egress_only_gateway_id    = try(each.value.egress_only_gateway_id, null)
  gateway_id                = try(each.value.gateway_id, null)
  local_gateway_id          = try(each.value.local_gateway_id, null)
  nat_gateway_id            = try(each.value.nat_gateway_id, null)
  network_interface_id      = try(each.value.network_interface_id, null)
  transit_gateway_id        = try(each.value.transit_gateway_id, null)
  vpc_endpoint_id           = try(each.value.vpc_endpoint_id, null)
  vpc_peering_connection_id = try(each.value.vpc_peering_connection_id, null)
}
