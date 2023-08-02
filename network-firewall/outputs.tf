output "id" {
  description = "Created Network Firewall ID from network_firewall module"
  value       = try(aws_networkfirewall_firewall.this[0].id, "")
}

output "arn" {
  description = "Created Network Firewall ARN from network_firewall module"
  value       = try(aws_networkfirewall_firewall.this[0].arn, "")
}

output "endpoint_id" {
  description = "Created Network Firewall endpoint id"
  value       = try(flatten(aws_networkfirewall_firewall.this[*].firewall_status[*].sync_states[*].*.attachment[*])[*].endpoint_id, "")
}
