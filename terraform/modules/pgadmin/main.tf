terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.20.0"
    }
  }
}

resource "docker_container" "pgadmin" {
  image = "dpage/pgadmin4:latest"
  name  = "pgadmin"
  ports {
    internal = 80
    external = 5050
  }
  env = [
    "DOCKER_REGISTRY_USER=admin",
    "DOCKER_REGISTRY_PASS=admin"
  ]
  networks_advanced {
    name = var.docker_network_id
    ipv4_address = var.docker_ip_address
  }
}