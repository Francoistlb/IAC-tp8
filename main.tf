module "services" {
  for_each = local.service_instances_map

  source = "./modules/service"

  name          = "${each.value.service_name_base}-${each.value.replica_num}"
  image         = each.value.image
  port_internal = each.value.port_internal
  port_external = each.value.port_external
  environment   = each.value.environment

  env_vars = {}
  command  = []
}
