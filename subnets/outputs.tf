output "private_subnets_id" {
  value = {
    for k, v in aws_subnet.private_subnets : k => v.id
  }
}

output "private_subnets_cidr" {
  value = {
    for k, v in aws_subnet.private_subnets : k => v.cidr_block
  }
}

output "public_subnets_id" {
  value = {
    for k, v in aws_subnet.public_subnets : k => v.id
  }
}

output "public_subnets_cidr" {
  value = {
    for k, v in aws_subnet.public_subnets : k => v.cidr_block
  }
}

output "other_subnets_id" {
  value = {
    for k, v in data.aws_subnet.other_subnets : k => v.id
  }
}

output "other_subnets_cidr" {
  value = {
    for k, v in data.aws_subnet.other_subnets : k => v.cidr_block
  }
}

output "public_subnets_az_wise_id" {
  value = {
    for k, v in aws_subnet.public_subnets : v.availability_zone => v.id...
  }
}

output "private_subnets_az_wise_id" {
  value = {
    for k, v in aws_subnet.private_subnets : v.availability_zone => v.id...
  }
}
