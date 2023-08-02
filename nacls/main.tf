module "nacl" {
  source = "./nacl"
  for_each = {
    for key, value in var.nacls :
    key => value
    if try(value.create, true)
  }
  vpc_id  = each.value["vpc_id"]
  name    = each.value["name"]
  subnets = try(each.value["subnets"], [])
  ingress_rules = try(each.value["ingress_rules"], {
    100 = {
      action     = "allow"
      from_port  = "-1"
      cidr_block = "0.0.0.0/0"
    }
  })
  egress_rules = try(each.value["egress_rules"], {
    100 = {
      action     = "allow"
      from_port  = "-1"
      cidr_block = "0.0.0.0/0"
    }
  })
}
