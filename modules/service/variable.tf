variable "name" {
  description = "Nom du conteneur"
  type        = string
}

variable "image" {
  description = "Image Docker à utiliser"
  type        = string
}

variable "port_internal" {
  description = "Port interne du conteneur"
  type        = number
}

variable "port_external" {
  description = "Port externe (port publié sur l'hôte)"
  type        = number
}

variable "environment" {
  description = "Environnement (dev/prod)"
  type        = string
  default     = "dev"
}

variable "env_vars" {
  description = "Variables d'environnement à passer au conteneur"
  type        = map(string)
  default     = {}
}

variable "command" {
  description = "Commande à exécuter au démarrage du conteneur"
  type        = list(string)
  default     = []
}
