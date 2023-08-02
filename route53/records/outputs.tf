output "route53_record_name" {
  description = "The name of the record"
  value       = { for k, v in aws_route53_record.this : k => v.name }
}

output "route53_record_fqdn" {
  description = "FQDN built using the zone domain and name"
  value       = { for k, v in aws_route53_record.this : k => v.fqdn }
}

output "route53_record_ip" {
  value = { for k, v in aws_route53_record.this : k => tolist(v.records)[0] if try(length(tolist(v.records)), 0) > 0 }
}

output "route53_record_ips" {
  value = { for k, v in aws_route53_record.this : k => v.records }
}
