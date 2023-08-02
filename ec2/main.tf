data "aws_ami" "amis" {
  for_each = {
    for key, item in var.properties :
    key => item
    if var.create && try(item.create, true) && length(item.ami) > 4 && substr(item.ami, 0, 4) != "ami-"
  }
  most_recent = true
  filter {
    name   = "tag:Name"
    values = [each.value.ami]
  }
}


locals {
  conf = [
    for key, item in var.properties : [
      for i in range(1, try(item.no_of_instances, 1) + 1) : {
        create                 = var.create && try(item.create, true)
        id                     = try(item.no_of_instances, 1) > 1 == false ? "${key}" : "${key}-${i}"
        name                   = try(item.special_names == [], true) ? try(item.add_suffix, try(item.no_of_instances, 1) > 1) == false ? "${item.name}" : "${item.name}-${i}" : try("${item.special_names["${i}" - 1]}", try(item.special_names[0], try(tostring(item.name), null)))
        ami                    = try(data.aws_ami.amis[key].id, item.ami)
        instance_type          = item.instance_type
        subnet_id              = item.subnet_id
        vpc_security_group_ids = item.vpc_security_group_ids
        iam_instance_profile   = try(item.iam_instance_profile, null)
        key_name               = try(item.key_name, null)
        root_block_device      = [try(item.root_block_device["${i}" - 1], try(item.root_block_device[0], {}))]
        private_ip             = try(item.private_ip["${"${i}" - 1}"], null)
        user_data              = try("${item.user_data["${i}" - 1]}", try(item.user_data, null))

        eip  = try(item.eip, false)
        tags = merge({ "Name" = try(item.special_names == [], true) ? try(item.add_suffix, try(item.no_of_instances, 1) > 1) == false ? "${item.name}" : "${item.name}-${i}" : try("${item.special_names["${i}" - 1]}", try(item.special_names[0], try(tostring(item.name), null))) }, var.tags, try(item.tags, {}), try("${item.special_tags["${i}" - 1]}", {}))

        ebs_block_device = try("${item.ebs_block_device["${i}" - 1]}", [])

        cpu_core_count                       = try(item.cpu_core_count, null)
        cpu_threads_per_core                 = try(item.cpu_threads_per_core, null)
        hibernation                          = try(item.hibernation, null)
        user_data_base64                     = try("${item.user_data_base64["${i}" - 1]}", try(item.user_data_base64, null))
        user_data_replace_on_change          = try("${item.user_data_replace_on_change["${i}" - 1]}", try(item.user_data_replace_on_change, null))
        availability_zone                    = try(item.availability_zone, null)
        monitoring                           = try(item.monitoring, false)
        get_password_data                    = try(item.get_password_data, null)
        associate_public_ip_address          = try("${item.associate_public_ip_address["${i}" - 1]}", null)
        secondary_private_ips                = try(item.secondary_private_ips, null)
        ipv6_address_count                   = try(item.ipv6_address_count, null)
        ipv6_addresses                       = try(item.ipv6_addresses, null)
        ebs_optimized                        = try(item.ebs_optimized, null)
        capacity_reservation_specification   = try(item.capacity_reservation_specification, {})
        ephemeral_block_device               = try(item.ephemeral_block_device, [])
        metadata_options                     = try(item.metadata_options, {})
        network_interface                    = try(item.network_interface, [])
        launch_template                      = try(item.launch_template, null)
        enclave_options_enabled              = try(item.enclave_options_enabled, null)
        source_dest_check                    = try(item.source_dest_check, null)
        disable_api_termination              = try(item.disable_api_termination, true)
        disable_api_stop                     = try(item.disable_api_stop, null)
        instance_initiated_shutdown_behavior = try(item.instance_initiated_shutdown_behavior, null)
        placement_group                      = try(item.placement_group, null)
        tenancy                              = try(item.tenancy, null)
        host_id                              = try(item.host_id, null)
        cpu_credits                          = try(item.cpu_credits, null)
        timeouts                             = try(item.timeouts, {})
        enable_volume_tags                   = try(item.enable_volume_tags, true)
        volume_tags                          = try(item.volume_tags, {})
      }
    ]
  ]
}

locals {
  instances = flatten(local.conf)
}


resource "aws_instance" "this" {
  # count = var.create && !var.create_spot_instance ? 1 : 0
  for_each = { for server in local.instances : server.id => server if server.create }

  ami                  = each.value.ami
  instance_type        = each.value.instance_type
  cpu_core_count       = each.value.cpu_core_count
  cpu_threads_per_core = each.value.cpu_threads_per_core
  hibernation          = each.value.hibernation

  user_data                   = each.value.user_data
  user_data_base64            = each.value.user_data_base64
  user_data_replace_on_change = each.value.user_data_replace_on_change

  availability_zone      = each.value.availability_zone
  subnet_id              = each.value.subnet_id
  vpc_security_group_ids = each.value.vpc_security_group_ids

  key_name             = each.value.key_name
  monitoring           = each.value.monitoring
  get_password_data    = each.value.get_password_data
  iam_instance_profile = each.value.iam_instance_profile

  associate_public_ip_address = each.value.associate_public_ip_address
  private_ip                  = each.value.private_ip
  secondary_private_ips       = each.value.secondary_private_ips
  ipv6_address_count          = each.value.ipv6_address_count
  ipv6_addresses              = each.value.ipv6_addresses

  ebs_optimized = each.value.ebs_optimized


  # Spot request specific attributes
  # resource "aws_spot_instance_request" "this" {
  # spot_price                     = var.spot_price
  # wait_for_fulfillment           = var.spot_wait_for_fulfillment
  # spot_type                      = var.spot_type
  # launch_group                   = var.spot_launch_group
  # block_duration_minutes         = var.spot_block_duration_minutes
  # instance_interruption_behavior = var.spot_instance_interruption_behavior
  # valid_until                    = var.spot_valid_until
  # valid_from                     = var.spot_valid_from
  # }
  # End spot request specific attributes

  dynamic "capacity_reservation_specification" {
    for_each = length(each.value.capacity_reservation_specification) > 0 ? [each.value.capacity_reservation_specification] : []
    content {
      capacity_reservation_preference = try(capacity_reservation_specification.value.capacity_reservation_preference, null)

      dynamic "capacity_reservation_target" {
        for_each = try([capacity_reservation_specification.value.capacity_reservation_target], [])
        content {
          capacity_reservation_id                 = try(capacity_reservation_target.value.capacity_reservation_id, null)
          capacity_reservation_resource_group_arn = try(capacity_reservation_target.value.capacity_reservation_resource_group_arn, null)
        }
      }
    }
  }

  dynamic "root_block_device" {
    for_each = each.value.root_block_device
    content {
      delete_on_termination = lookup(root_block_device.value, "delete_on_termination", null)
      encrypted             = lookup(root_block_device.value, "encrypted", null)
      iops                  = lookup(root_block_device.value, "iops", null)
      kms_key_id            = lookup(root_block_device.value, "kms_key_id", null)
      volume_size           = lookup(root_block_device.value, "volume_size", null)
      volume_type           = lookup(root_block_device.value, "volume_type", null)
      throughput            = lookup(root_block_device.value, "throughput", null)
      tags                  = lookup(root_block_device.value, "tags", null)
    }
  }

  dynamic "ebs_block_device" {
    for_each = each.value.ebs_block_device
    content {
      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", null)
      device_name           = ebs_block_device.value.device_name
      encrypted             = lookup(ebs_block_device.value, "encrypted", null)
      iops                  = lookup(ebs_block_device.value, "iops", null)
      kms_key_id            = lookup(ebs_block_device.value, "kms_key_id", null)
      snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
      volume_size           = lookup(ebs_block_device.value, "volume_size", null)
      volume_type           = lookup(ebs_block_device.value, "volume_type", null)
      throughput            = lookup(ebs_block_device.value, "throughput", null)
    }
  }

  dynamic "ephemeral_block_device" {
    for_each = each.value.ephemeral_block_device
    content {
      device_name  = ephemeral_block_device.value.device_name
      no_device    = lookup(ephemeral_block_device.value, "no_device", null)
      virtual_name = lookup(ephemeral_block_device.value, "virtual_name", null)
    }
  }

  dynamic "metadata_options" {
    for_each = each.value.metadata_options != null ? [each.value.metadata_options] : []
    content {
      http_endpoint               = lookup(metadata_options.value, "http_endpoint", "enabled")
      http_tokens                 = lookup(metadata_options.value, "http_tokens", "optional")
      http_put_response_hop_limit = lookup(metadata_options.value, "http_put_response_hop_limit", "1")
      instance_metadata_tags      = lookup(metadata_options.value, "instance_metadata_tags", null)
    }
  }

  dynamic "network_interface" {
    for_each = each.value.network_interface
    content {
      device_index          = network_interface.value.device_index
      network_interface_id  = lookup(network_interface.value, "network_interface_id", null)
      delete_on_termination = lookup(network_interface.value, "delete_on_termination", false)
    }
  }

  dynamic "launch_template" {
    for_each = each.value.launch_template != null ? [each.value.launch_template] : []
    content {
      id      = lookup(each.value.launch_template, "id", null)
      name    = lookup(each.value.launch_template, "name", null)
      version = lookup(each.value.launch_template, "version", null)
    }
  }

  enclave_options {
    enabled = each.value.enclave_options_enabled
  }

  source_dest_check                    = length(each.value.network_interface) > 0 ? null : each.value.source_dest_check
  disable_api_termination              = each.value.disable_api_termination
  disable_api_stop                     = each.value.disable_api_stop
  instance_initiated_shutdown_behavior = each.value.instance_initiated_shutdown_behavior
  placement_group                      = each.value.placement_group
  tenancy                              = each.value.tenancy
  host_id                              = each.value.host_id

  credit_specification {
    cpu_credits = replace(each.value.instance_type, "/^t(2|3|3a){1}\\..*$/", "1") == "1" ? each.value.cpu_credits : null
  }

  timeouts {
    create = lookup(each.value.timeouts, "create", null)
    update = lookup(each.value.timeouts, "update", null)
    delete = lookup(each.value.timeouts, "delete", null)
  }

  tags        = each.value.tags
  volume_tags = each.value.enable_volume_tags ? merge({ "Name" = each.value.name }, each.value.volume_tags) : null

  lifecycle {
    ignore_changes = [
      ami
    ]
  }
}

resource "aws_eip_association" "this" {
  for_each = {
    for server in local.instances : server.id => server
    if server.create && try(length(tostring(server.eip)) > 9 && substr(tostring(server.eip), 0, 9) == "eipalloc-", false)
  }

  instance_id   = aws_instance.this[each.key].id
  allocation_id = each.value.eip
}

resource "aws_eip" "this" {
  for_each = {
    for server in local.instances : server.id => server
    if server.create && try(tobool(server.eip), false)
  }

  instance = aws_instance.this[each.key].id
  vpc      = "true"
  tags     = each.value.tags
}
