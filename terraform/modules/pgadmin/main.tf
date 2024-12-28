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
  environment = {
    PGADMIN_DEFAULT_EMAIL = "admin@admin.com"
    PGADMIN_DEFAULT_PASSWORD = "admin" # Această parolă va fi mutată în Vault
  }
  volumes {
    driver = "local"
    name   = "pgadmin-data"
  }
  networks_advanced {
    name = var.docker_network_id
    ip_address = var.docker_ip_address
  }
}