output "deployed_services" {
  description = "Résumé des services déployés"
  value = {
    for key, module in module.services :
    key => {
      name             = module.container_name
      image            = module.container_image
      port_external    = module.port_external
      port_internal    = module.port_internal
      container_id     = module.container_id
      container_status = module.container_status
    }
  }
}

output "services_summary" {
  description = "Résumé des services par type"
  value = {
    environment       = var.environment
    total_services    = length(local.filtered_services)
    total_instances   = length(local.service_instances_map)
    services_deployed = keys(local.filtered_services)
  }
}

output "service_details" {
  description = "Détails de chaque service déployé"
  value = {
    for name, service in local.filtered_services :
    name => {
      name        = service.name
      image       = service.image
      replicas    = service.replicas
      ports       = "Interne: ${service.port_internal} → Externe: ${service.port_external}-${service.port_external + service.replicas - 1}"
      enable      = service.enable
      environment = service.environment
    }
  }
}
