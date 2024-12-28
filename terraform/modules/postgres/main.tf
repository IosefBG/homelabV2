terraform {
  required_providers {
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "~> 1.25.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.0"
    }
  }
}

resource "random_password" "password" {
  length = 16
  special = true
  override_special = "_%@"
}

resource "postgresql_database" "main" {
  name = var.db_name
}

resource "postgresql_role" "vault_user" {
  name = "vault_user"
}

resource "postgresql_user_mapping" "vault_user" {
  server_name = postgresql_database.main.name
  user_name   = var.db_username
  options = {
    user     = var.db_username
    password = random_password.password.result
  }
}

resource "docker_container" "postgres" {
  image = "postgres:latest"
  name  = "postgres"
  ports {
    internal = 5432
    external = 5432
  }
  env = [
    "POSTGRES_DB=${var.db_name}",
    "POSTGRES_USER=${var.db_username}",
    "POSTGRES_PASSWORD=${random_password.password.result}"
  ]
  networks_advanced {
    name = var.docker_network_id
    ipv4_address = var.docker_ip_address
  }
  dns = ["8.8.8.8", "8.8.4.4"]
}