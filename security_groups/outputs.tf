output "ids" {
  value = {
    for k, v in merge(aws_security_group.this, data.aws_security_group.others) : k => v.id
  }
}
