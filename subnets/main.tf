data "aws_subnet" "other_subnets" {
  for_each = try(var.subnets.others, {})
  id       = each.value
}

resource "aws_subnet" "private_subnets" {
  for_each                = try(var.subnets.private, {})
  cidr_block              = each.value["cidr"]
  vpc_id                  = each.value["vpc_id"]
  map_public_ip_on_launch = false
  availability_zone       = each.value["region"]
  tags = merge(
    {
      Name = each.value["name"]
    },
    var.tags,
    try(each.value.tags, {})
  )
}

resource "aws_subnet" "public_subnets" {
  for_each                = try(var.subnets.public, {})
  cidr_block              = each.value["cidr"]
  vpc_id                  = each.value["vpc_id"]
  map_public_ip_on_launch = try(each.value["map_public_ip_on_launch"], true)
  availability_zone       = each.value["region"]
  tags = merge({
    Name = each.value["name"]
    },
    var.tags,
    try(each.value.tags, {})
  )
}
