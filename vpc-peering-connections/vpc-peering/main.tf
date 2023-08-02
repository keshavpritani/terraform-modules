
###################################################
# VPC Peering
###################################################

resource "aws_vpc_peering_connection" "this" {
  vpc_id      = var.requester_vpc_id
  peer_vpc_id = var.accepter_vpc_id
  auto_accept = true

  requester {
    allow_remote_vpc_dns_resolution = var.requester_allow_remote_vpc_dns_resolution
  }

  accepter {
    allow_remote_vpc_dns_resolution = var.accepter_allow_remote_vpc_dns_resolution
  }

  tags = {
    Name = var.name
  }
}

# data "aws_caller_identity" "this" {}
# data "aws_region" "this" {}

# locals {
#   requester = {
#     account_id = data.aws_caller_identity.this.account_id
#     region     = data.aws_region.this.name
#     vpc_id     = var.requester_vpc_id
#     cidr_block = data.aws_vpc.requester.cidr_block
#     secondary_cidr_blocks = [
#       for association in data.aws_vpc.requester.cidr_block_associations :
#       association.cidr_block
#       if association.cidr_block != data.aws_vpc.requester.cidr_block
#     ]
#   }
#   accepter = {
#     account_id = data.aws_caller_identity.this.account_id
#     region     = data.aws_region.this.name
#     vpc_id     = var.accepter_vpc_id
#     cidr_block = data.aws_vpc.accepter.cidr_block
#     secondary_cidr_blocks = [
#       for association in data.aws_vpc.accepter.cidr_block_associations :
#       association.cidr_block
#       if association.cidr_block != data.aws_vpc.accepter.cidr_block
#     ]
#   }
# }

data "aws_vpc" "requester" {
  id = var.requester_vpc_id
}

data "aws_vpc" "accepter" {
  id = var.accepter_vpc_id
}

module "requester_route" {
  source         = "../../route_tables/routes"
  for_each       = var.requester_rt_ids
  route_table_id = each.value
  ipv4_routes = [
    {
      cidr_block                = data.aws_vpc.accepter.cidr_block,
      vpc_peering_connection_id = aws_vpc_peering_connection.this.id
    }
  ]
}

module "accepter_route" {
  source         = "../../route_tables/routes"
  for_each       = var.accepter_rt_ids
  route_table_id = each.value
  ipv4_routes = [
    {
      cidr_block                = data.aws_vpc.requester.cidr_block,
      vpc_peering_connection_id = aws_vpc_peering_connection.this.id
    }
  ]
}
