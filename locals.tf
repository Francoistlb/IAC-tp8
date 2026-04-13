locals {
  # Filtrer les services : actifs ET appartenant à l'environnement courant
  filtered_services = {
    for name, service in var.services :
    name => service
    if service.enable && service.environment == var.environment
  }

  # Créer des instances de services avec leurs replicas
  service_instances = flatten([
    for service_key, service in local.filtered_services : [
      for replica_num in range(service.replicas) : {
        key               = "${service_key}-${replica_num}"
        service_name_base = service.name
        service_key       = service_key
        image             = service.image
        port_internal     = service.port_internal
        port_external     = service.port_external + replica_num
        replica_num       = replica_num
        environment       = service.environment
      }
    ]
  ])

  # Convertir la liste en map pour utilisation avec for_each
  service_instances_map = {
    for instance in local.service_instances :
    instance.key => instance
  }
}
