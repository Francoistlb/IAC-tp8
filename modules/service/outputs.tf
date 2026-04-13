output "container_id" {
  description = "ID du conteneur Docker"
  value       = docker_container.service.id
}

output "container_name" {
  description = "Nom du conteneur"
  value       = docker_container.service.name
}

output "container_image" {
  description = "Image Docker utilisée"
  value       = var.image
}

output "port_internal" {
  description = "Port interne du conteneur"
  value       = var.port_internal
}

output "port_external" {
  description = "Port externe (port publié)"
  value       = var.port_external
}

output "container_status" {
  description = "Statut du conteneur"
  value       = "running"
}
