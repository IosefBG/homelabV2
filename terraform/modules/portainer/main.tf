resource "docker_container" "portainer" {
  image = "portainer/portainer-ce:latest"
  name  = "portainer"
  ports {
    internal = 9000
    external = 9000
  }
  volumes {
    driver = "local"
    name   = "portainer-data"
  }
  networks_advanced {
    name = var.docker_network_id
    ip_address = var.docker_ip_address
  }
}