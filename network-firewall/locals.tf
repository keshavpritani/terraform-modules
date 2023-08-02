locals {
  vpn_endpoint_az_wize = {
    for value in flatten(aws_networkfirewall_firewall.this[*].firewall_status[*].sync_states[*].*) : value.availability_zone => flatten(value.attachment[*].endpoint_id)[0]
  }

  az_rt_ids = {
    for key, value in data.aws_route_table.az_rts : key => value.id
  }

  this_stateful_group_arn  = concat(aws_networkfirewall_rule_group.suricata_stateful_group.*.arn, aws_networkfirewall_rule_group.domain_stateful_group.*.arn, aws_networkfirewall_rule_group.fivetuple_stateful_group.*.arn)
  this_stateless_group_arn = concat(aws_networkfirewall_rule_group.stateless_group.*.arn)
}
