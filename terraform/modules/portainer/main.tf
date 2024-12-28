terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.20.0"
    }
  }
}

resource "docker_container" "portainer" {
  image = "portainer/portainer-ce:latest"
  name  = "portainer"
  ports {
    internal = 9000
    external = 9000
  }
  networks_advanced {
    name = var.docker_network_id
    ipv4_address = var.docker_ip_address
  }
}