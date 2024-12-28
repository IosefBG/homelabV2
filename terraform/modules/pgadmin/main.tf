terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.0"
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
  dns = ["8.8.8.8", "8.8.4.4"]
}