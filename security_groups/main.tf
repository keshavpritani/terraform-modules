data "aws_security_group" "others" {
  for_each = {
    for key, value in var.sgs :
    key => value
    if try(length(tostring(value)) > 3, true) && try(substr(tostring(value), 0, 3) == "sg-", false)
  }
  id = each.value
}

resource "aws_security_group" "this" {
  for_each = {
    for key, value in var.sgs :
    key => value
    if try(length(tostring(value)) > 3, true) && try(substr(tostring(value), 0, 3) != "sg-", true)
  }

  vpc_id = try(each.value["vpc_id"], var.vpc_id)

  name = try(tostring(each.value), try(each.value["name"], null))
  # name_prefix = var.name_prefix
  description = try(each.value["description"], "Managed by Terraform")

  revoke_rules_on_delete = try(each.value["revoke_rules_on_delete"], false)

  tags = merge(
    {
      "Name" = try(tostring(each.value), try(each.value["name"], null))
    },
    try(each.value["tags"], {}),
  )
}

module "security_groups_rule_common" {
  for_each = {
    for key, value in var.sgs :
    key => value
    if try(length(tostring(value)) > 3, true) && try(substr(tostring(value), 0, 3) != "sg-", true)
  }
  source = "./security_groups_rule"
  sg_id  = aws_security_group.this[each.key].id
  ingress_rules = try(each.value.no_self_allowed, false) == true ? [] : [
    {
      from_port   = -1
      protocol    = "-1"
      self        = true
      description = "All traffic for Self SG"
    }
  ]
  egress_rules = try(each.value.no_egress, false) == true ? [] : [
    {
      from_port   = -1
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}
