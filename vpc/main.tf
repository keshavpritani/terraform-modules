data "aws_vpc" "others" {
  for_each = {
    for key, value in var.vpcs :
    key => value
    if try(length(tostring(value)) > 4, false) && try(substr(tostring(value), 0, 4) == "vpc-", false)
  }
  id = each.value
}

resource "aws_vpc" "vpc" {
  for_each = {
    for key, value in var.vpcs :
    key => value
    if try(length(tostring(value)) == 0, true)
  }
  cidr_block           = each.value["cidr"]
  enable_dns_hostnames = try(each.value["enable_dns_hostnames"], true)
  tags = {
    Name = each.value["name"]
  }
}

#output
output "vpcs_id" {
  value = {
    for k, v in merge(aws_vpc.vpc, data.aws_vpc.others) : k => v.id
  }
}
output "vpcs_cidr_block" {
  value = {
    for k, v in merge(aws_vpc.vpc, data.aws_vpc.others) : k => v.cidr_block
  }
}
