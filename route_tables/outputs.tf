output "ids" {
  value = {
    for k, v in module.route_table : k => v.id
  }
}
