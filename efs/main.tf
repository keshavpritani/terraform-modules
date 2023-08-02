locals {
  enabled = var.create

  # Returning null in the lookup function gives type errors and is not omitting the parameter.
  # This work around ensures null is returned.
  posix_users = {
    for k, v in try(var.access_points, {}) :
    k => lookup(var.access_points[k], "posix_user", {})
  }
  secondary_gids = {
    for k, v in try(var.access_points, {}) :
    k => lookup(local.posix_users[k], "secondary_gids", null)
  }
}

resource "aws_efs_file_system" "default" {
  #bridgecrew:skip=BC_AWS_GENERAL_48: BC complains about not aving an AWS Backup plan. We ignore this because this can be done outside of this module.
  count                           = local.enabled ? 1 : 0
  tags                            = var.tags
  availability_zone_name          = var.availability_zone_name
  encrypted                       = var.encrypted
  kms_key_id                      = var.kms_key_id
  performance_mode                = var.performance_mode
  provisioned_throughput_in_mibps = var.provisioned_throughput_in_mibps
  throughput_mode                 = var.throughput_mode

  dynamic "lifecycle_policy" {
    for_each = length(var.transition_to_ia) > 0 ? [1] : []
    content {
      transition_to_ia = try(var.transition_to_ia[0], null)
    }
  }

  dynamic "lifecycle_policy" {
    for_each = length(var.transition_to_primary_storage_class) > 0 ? [1] : []
    content {
      transition_to_primary_storage_class = try(var.transition_to_primary_storage_class[0], null)
    }
  }
}

resource "aws_efs_mount_target" "default" {
  count           = local.enabled && length(var.subnets) > 0 ? length(var.subnets) : 0
  file_system_id  = join("", aws_efs_file_system.default.*.id)
  ip_address      = var.mount_target_ip_address
  subnet_id       = var.subnets[count.index]
  security_groups = var.associated_security_group_ids
}

resource "aws_efs_access_point" "default" {
  for_each = local.enabled ? var.access_points : {}

  file_system_id = join("", aws_efs_file_system.default.*.id)

  dynamic "posix_user" {
    for_each = local.posix_users[each.key] != null ? ["true"] : []

    content {
      gid            = local.posix_users[each.key]["gid"]
      uid            = local.posix_users[each.key]["uid"]
      secondary_gids = local.secondary_gids[each.key] != null ? split(",", local.secondary_gids[each.key]) : null
    }
  }

  root_directory {
    path = "/${each.key}"

    dynamic "creation_info" {
      for_each = try(var.access_points[each.key]["creation_info"]["gid"], "") != "" ? ["true"] : []

      content {
        owner_gid   = var.access_points[each.key]["creation_info"]["gid"]
        owner_uid   = var.access_points[each.key]["creation_info"]["uid"]
        permissions = var.access_points[each.key]["creation_info"]["permissions"]
      }
    }
  }

  tags = var.tags
}

module "dns" {
  source = "../route53/records"

  create  = local.enabled && length(var.zone_id) > 0 && (length(tostring(var.dns_name)) > 0 || try(length(tostring(var.tags["Name"])), 0) > 0)
  zone_id = var.zone_id[0]
  records = [
    {
      name    = length(var.dns_name) > 0 ? var.dns_name : var.tags["Name"]
      type    = "CNAME"
      records = [try(aws_efs_file_system.default[0].dns_name, "")]
    }
  ]
}

resource "aws_efs_backup_policy" "policy" {
  count = var.create ? 1 : 0

  file_system_id = join("", aws_efs_file_system.default.*.id)

  backup_policy {
    status = var.efs_backup_policy_enabled ? "ENABLED" : "DISABLED"
  }
}
