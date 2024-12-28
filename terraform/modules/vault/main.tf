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
  volumes {
    driver = "local"
    name   = "vault-data"
  }
  command = ["server", "-dev", "-dev-root-token-id=root"]
  networks_advanced {
    name = var.docker_network_id
    ip_address = var.docker_ip_address
  }
}