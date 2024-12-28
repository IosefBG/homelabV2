terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.20.0"
    }
  }
}

resource "docker_container" "vault" {
  image = "vault:latest"
  name  = "vault"
  ports {
    internal = 8200
    external = 8200
  }
  command = ["server", "-dev", "-dev-root-token-id=root"]
  networks_advanced {
    name = var.docker_network_id
    ipv4_address = var.docker_ip_address
  }
}