output "ids" {
  value = {
    for k, v in aws_instance.this : k => v.id
  }
}

output "private_ips" {
  value = {
    for k, v in aws_instance.this : k => v.private_ip
  }
}

output "public_ips" {
  value = {
    for k, v in aws_instance.this : k => v.public_ip
    if v.public_ip != ""
  }
}

output "eip_ips" {
  value = {
    for k, v in aws_instance.this : k => v.public_ip
    if v.public_ip != "" && try(aws_eip.this[k].public_ip != "", false)
  }
}

# output "instances" {
# 	value = {for key, server in local.instances: server.id => server}
# }
