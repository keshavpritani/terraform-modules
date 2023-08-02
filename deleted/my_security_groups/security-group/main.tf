
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
}


module "security-group-rule" {
  source        = "../security-group-rule"
  sg_id         = aws_security_group.this.id
  ingress_rules = var.ingress_rules
  egress_rules  = var.egress_rules
}
