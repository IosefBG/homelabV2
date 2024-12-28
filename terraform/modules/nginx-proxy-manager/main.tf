terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.20.0"
    }
  }
}

resource "docker_container" "nginx-proxy-manager" {
  image = "jc21/nginx-proxy-manager:latest"
  name  = "nginx-proxy-manager"
  ports {
    internal = 80
    external = 80
  }
  ports {
    internal = 81
    external = 81
  }
  ports {
    internal = 443
    external = 443
  }
  restart = "always"
  networks_advanced {
    name = var.docker_network_id
    ipv4_address = var.docker_ip_address
  }
}