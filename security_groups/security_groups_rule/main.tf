###################################################
# Security Group Rules
###################################################

locals {
  normalized_ingress_rules = [
    for rule in var.ingress_rules : {
      id = try(rule.id, format("%s:%s", try(rule.from_port, rule.port), try(rule.to_port, try(rule.from_port, rule.port))))
      # id = key
      description = lookup(rule, "description", try(rule.id, null))
      sg_id       = lookup(rule, "sg_id", var.sg_id)
      protocol    = try(rule.protocol, "tcp")
      from_port   = try(rule.from_port, rule.port)
      to_port     = try(rule.to_port, try(rule.from_port, rule.port))

      cidr_blocks              = try(sort(compact(rule.cidr_blocks)), null)
      ipv6_cidr_blocks         = try(sort(compact(rule.ipv6_cidr_blocks)), null)
      prefix_list_ids          = try(sort(compact(rule.prefix_list_ids)), null)
      source_security_group_id = try(rule.source_security_group_id, null)
      self                     = try(rule.self, false) ? true : null
    }
  ]
  normalized_egress_rules = [
    for rule in var.egress_rules : {
      id          = try(rule.id, format("%s:%s", try(rule.from_port, rule.port), try(rule.to_port, try(rule.from_port, rule.port))))
      description = lookup(rule, "description", null)
      sg_id       = lookup(rule, "sg_id", var.sg_id)
      protocol    = try(rule.protocol, "tcp")
      from_port   = try(rule.from_port, rule.port)
      to_port     = try(rule.to_port, try(rule.from_port, rule.port))

      cidr_blocks              = try(sort(compact(rule.cidr_blocks)), null)
      ipv6_cidr_blocks         = try(sort(compact(rule.ipv6_cidr_blocks)), null)
      prefix_list_ids          = try(sort(compact(rule.prefix_list_ids)), null)
      source_security_group_id = try(rule.source_security_group_id, null)
      self                     = try(rule.self, false) ? true : null
    }
  ]
}

resource "aws_security_group_rule" "ingress" {
  for_each = {
    for rule in local.normalized_ingress_rules :
    rule.id => rule
  }
  # for_each = var.ingress_rules

  security_group_id = each.value.sg_id
  type              = "ingress"
  description       = each.value.description

  protocol  = each.value.protocol
  from_port = each.value.from_port
  to_port   = each.value.to_port

  cidr_blocks              = each.value.cidr_blocks
  ipv6_cidr_blocks         = each.value.ipv6_cidr_blocks
  prefix_list_ids          = each.value.prefix_list_ids
  source_security_group_id = each.value.source_security_group_id
  self                     = each.value.self
}

resource "aws_security_group_rule" "egress" {
  for_each = {
    for rule in local.normalized_egress_rules :
    rule.id => rule
  }

  security_group_id = each.value.sg_id
  type              = "egress"
  description       = each.value.description

  protocol  = each.value.protocol
  from_port = each.value.from_port
  to_port   = each.value.to_port

  cidr_blocks              = each.value.cidr_blocks
  ipv6_cidr_blocks         = each.value.ipv6_cidr_blocks
  prefix_list_ids          = each.value.prefix_list_ids
  source_security_group_id = each.value.source_security_group_id
  self                     = each.value.self
}
