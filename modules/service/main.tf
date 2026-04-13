resource "docker_image" "service" {
  name         = var.image
  keep_locally = true
}

resource "docker_container" "service" {
  name     = "${var.name}-${var.environment}"
  image    = docker_image.service.image_id
  must_run = true
  restart  = "always"
  command  = var.command != [] ? var.command : null
  env      = [for k, v in var.env_vars : "${k}=${v}"]

  ports {
    internal = var.port_internal
    external = var.port_external
  }
}
