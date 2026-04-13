variable "environment" {
  description = "Environnement de déploiement (dev ou prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "L'environnement doit être 'dev' ou 'prod'."
  }
}

variable "services" {
  description = "Configuration complète des services"
  type = map(object({
    name          = string
    image         = string
    port_internal = number
    port_external = number
    environment   = string
    replicas      = number
    enable        = bool
  }))

  default = {
    frontend = {
      name          = "frontend"
      image         = "nginx:latest"
      port_internal = 80
      port_external = 8090
      environment   = "dev"
      replicas      = 1
      enable        = true
    }
    backend = {
      name          = "backend"
      image         = "node:18-alpine"
      port_internal = 3000
      port_external = 8091
      environment   = "dev"
      replicas      = 1
      enable        = false
    }
    database = {
      name          = "database"
      image         = "postgres:15-alpine"
      port_internal = 5432
      port_external = 8092
      environment   = "dev"
      replicas      = 1
      enable        = false
    }
    cache = {
      name          = "cache"
      image         = "redis:7-alpine"
      port_internal = 6379
      port_external = 8093
      environment   = "dev"
      replicas      = 1
      enable        = true
    }
  }
}
