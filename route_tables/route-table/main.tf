
resource "aws_route_table" "this" {
  vpc_id = var.vpc_id

  tags = {
    "Name" = var.name
  }
}

resource "aws_main_route_table_association" "this" {
  count          = var.is_main ? 1 : 0
  vpc_id         = var.vpc_id
  route_table_id = aws_route_table.this.id
}


module "routes" {
  source             = "../routes"
  route_table_id     = aws_route_table.this.id
  ipv4_routes        = var.ipv4_routes
  ipv6_routes        = var.ipv6_routes
  prefix_list_routes = var.prefix_list_routes
}

###################################################
# Associations
###################################################

# INFO: Conflict on create with `for_each`
resource "aws_route_table_association" "subnets" {
  count = length(var.subnets)

  route_table_id = aws_route_table.this.id
  subnet_id      = var.subnets[count.index]
}

resource "aws_route_table_association" "gateways" {
  for_each = toset(var.gateways)

  route_table_id = aws_route_table.this.id
  gateway_id     = each.value
}


###################################################
# VPC Gateway Endpoint Association
###################################################

resource "aws_vpc_endpoint_route_table_association" "this" {
  for_each = toset(var.vpc_gateway_endpoints)

  route_table_id  = aws_route_table.this.id
  vpc_endpoint_id = each.value
}


###################################################
# Route Propagations
###################################################

resource "aws_vpn_gateway_route_propagation" "this" {
  for_each = toset(var.propagating_vpn_gateways)

  route_table_id = aws_route_table.this.id
  vpn_gateway_id = each.value
}
