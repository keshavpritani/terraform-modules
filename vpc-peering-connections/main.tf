module "vpc_peering_connections" {
  source                                    = "./vpc-peering"
  for_each                                  = var.vpc_peering_connections
  name                                      = each.value["name"]
  requester_vpc_id                          = each.value["requester_vpc_id"]
  accepter_vpc_id                           = each.value["accepter_vpc_id"]
  requester_allow_remote_vpc_dns_resolution = try(each.value["requester_allow_remote_vpc_dns_resolution"], false)
  accepter_allow_remote_vpc_dns_resolution  = try(each.value["accepter_allow_remote_vpc_dns_resolution"], false)
  requester_rt_ids                          = try(each.value["requester_rt_ids"], {})
  accepter_rt_ids                           = try(each.value["accepter_rt_ids"], {})
}
