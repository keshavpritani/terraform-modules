########## Internet Gateway #####################

resource "aws_internet_gateway" "gw" {
  count  = length(var.igw_rt_ids) > 0 || length(var.igw_rt_ids_assocation) > 0 ? 1 : 0
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.name}"
  }
}
########### NAT gateway ########
resource "aws_eip" "nat" {
  count = var.want_nat && var.eip_id == "new" && var.is_nat_public ? 1 : 0
  vpc   = true
  tags = {
    Name = "${var.name}-NAT"
  }
}
data "aws_eip" "nat" {
  count = var.want_nat && var.eip_id != "new" && var.is_nat_public ? 1 : 0
  id    = var.eip_id
}

resource "aws_nat_gateway" "gw" {
  count             = var.want_nat ? 1 : 0
  allocation_id     = var.is_nat_public ? try(aws_eip.nat[0].id, var.eip_id) : null
  subnet_id         = var.nat_subnet_id
  connectivity_type = var.is_nat_public ? "public" : "private"
  depends_on        = [aws_internet_gateway.gw]
  tags = {
    Name = "${var.name}"
  }
}

module "igw_route" {
  source         = "../route_tables/routes"
  count          = length(var.igw_rt_ids)
  route_table_id = var.igw_rt_ids[count.index]
  ipv4_routes = [
    {
      cidr_block = "0.0.0.0/0",
      gateway_id = aws_internet_gateway.gw[0].id
    }
  ]
}

resource "aws_route_table_association" "rt_gateways" {
  count = length(var.igw_rt_ids_assocation)

  route_table_id = var.igw_rt_ids_assocation[count.index]
  gateway_id     = aws_internet_gateway.gw[0].id
}

module "nat_route" {
  source         = "../route_tables/routes"
  count          = var.want_nat ? length(var.nat_rt_ids) : 0
  route_table_id = var.nat_rt_ids[count.index]
  ipv4_routes = [
    {
      cidr_block     = "0.0.0.0/0",
      nat_gateway_id = aws_nat_gateway.gw[0].id
    }
  ]
}

output "igw_id" {
  value = try(aws_internet_gateway.gw[0].id, null)
}

output "nat_id" {
  value = try(aws_nat_gateway.gw[0].id, null)
}

output "nat_eip_ip" {
  value = try(try(aws_eip.nat[0].public_ip, data.aws_eip.nat[0].public_ip), "")
}
