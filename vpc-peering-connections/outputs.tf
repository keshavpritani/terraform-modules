output "ids" {
  value = {
    for k, v in module.vpc_peering_connections : k => v.id
  }
}
