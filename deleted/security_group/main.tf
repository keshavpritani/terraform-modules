
resource "aws_security_group" "this" {
  vpc_id = var.vpc_id

  name = var.name
  # name_prefix = var.name_prefix
  description = var.description

  revoke_rules_on_delete = var.revoke_rules_on_delete

  tags = merge(
    {
      "Name" = var.name
    },
    var.tags,
  )
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port        = try(ingress.value.from_port, null)
      to_port          = try(ingress.value.to_port, null)
      protocol         = try(ingress.value.protocol, null)
      description      = try(ingress.value.description, "Managed by Terraform")
      cidr_blocks      = try(ingress.value.cidr_blocks, null)
      ipv6_cidr_blocks = try(ingress.value.ipv6_cidr_blocks, null)
      prefix_list_ids  = try(ingress.value.prefix_list_ids, null)
      security_groups  = try(ingress.value.security_groups, null)
      self             = try(ingress.value.self, false)
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port        = try(egress.value.from_port, null)
      to_port          = try(egress.value.to_port, null)
      protocol         = try(egress.value.protocol, null)
      description      = try(egress.value.description, "Managed by Terraform")
      cidr_blocks      = try(egress.value.cidr_blocks, null)
      ipv6_cidr_blocks = try(egress.value.ipv6_cidr_blocks, null)
      prefix_list_ids  = try(egress.value.prefix_list_ids, null)
      security_groups  = try(egress.value.security_groups, null)
      self             = try(egress.value.self, false)
    }
  }

}


# module "security-group-rule" {
# 	source  = "./security-group-rule"
#   sg_id = aws_security_group.this.id
#   ingress_rules = var.ingress_rules
#   egress_rules = var.egress_rules
# }
