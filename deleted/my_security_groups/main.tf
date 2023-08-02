module "sg" {
  source   = "./security-group"
  for_each = var.sgs
  vpc_id   = each.value["vpc_id"]
  name     = try(each.value["name"], null)
  # name_prefix = try(each.value["name_prefix"], null)
  description            = try(each.value["description"], "Managed by Terraform")
  revoke_rules_on_delete = try(each.value["revoke_rules_on_delete"], false)
  ingress_rules          = try(each.value["ingress_rules"], [])
  egress_rules           = try(each.value["egress_rules"], [])
  tags                   = try(each.value["tags"], {})
}