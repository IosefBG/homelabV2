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
  volumes {
    driver = "local"
    name   = "nginx-proxy-manager-data"
  }
  restart = "always"
  networks_advanced {
    name = var.docker_network_id
    ip_address = var.docker_ip_address
  }
}