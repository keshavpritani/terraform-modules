
output "ids" {
  value = {
    for k, v in module.sg : k => v.id
  }
}

output "normalized_ingress_rules" {
  value = {
    for k, v in module.sg : k => v.normalized_ingress_rules
  }
}


output "normalized_egress_rules" {
  value = {
    for k, v in module.sg : k => v.normalized_egress_rules
  }
}
