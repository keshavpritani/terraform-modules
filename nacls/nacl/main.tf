resource "aws_network_acl" "this" {
  vpc_id     = var.vpc_id
  subnet_ids = var.subnets
  tags = {
    Name = var.name
  }
}


###################################################
# Network ACL Rules
###################################################

resource "aws_network_acl_rule" "ingress" {
  for_each = {
    for key, value in var.ingress_rules :
    key => value
    if try(value.create, true)
  }

  network_acl_id = aws_network_acl.this.id

  egress          = false
  rule_number     = each.key
  rule_action     = lookup(each.value, "action", "")
  protocol        = lookup(each.value, "protocol", -1)
  from_port       = lookup(each.value, "from_port", null)
  to_port         = lookup(each.value, "to_port", lookup(each.value, "from_port", null))
  icmp_type       = lookup(each.value, "icmp_type", null)
  icmp_code       = lookup(each.value, "icmp_code", null)
  cidr_block      = lookup(each.value, "cidr_block", null)
  ipv6_cidr_block = lookup(each.value, "ipv6_cidr_block", null)
}

resource "aws_network_acl_rule" "egress" {
  for_each = {
    for key, value in var.egress_rules :
    key => value
    if try(value.create, true)
  }

  network_acl_id = aws_network_acl.this.id

  egress          = true
  rule_number     = each.key
  rule_action     = lookup(each.value, "action", "")
  protocol        = lookup(each.value, "protocol", -1)
  from_port       = lookup(each.value, "from_port", null)
  to_port         = lookup(each.value, "to_port", lookup(each.value, "from_port", null))
  icmp_type       = lookup(each.value, "icmp_type", null)
  icmp_code       = lookup(each.value, "icmp_code", null)
  cidr_block      = lookup(each.value, "cidr_block", null)
  ipv6_cidr_block = lookup(each.value, "ipv6_cidr_block", null)
}
