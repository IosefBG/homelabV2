terraform {
  required_providers {
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "~> 1.14.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.20.0"
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

resource "postgresql_user" "vault_user" {
  name     = var.db_username
  password = random_password.password.result
}

resource "postgresql_database_role_attachment" "vault_user" {
  database_name = postgresql_database.main.name
  role_name     = postgresql_user.vault_user.name
}

resource "docker_container" "postgres" {
  image = "postgres:latest"
  name  = "postgres"
  ports {
    internal = 5432
    external = 5432
  }
  environment = {
    POSTGRES_DB       = var.db_name
    POSTGRES_USER     = var.db_username
    POSTGRES_PASSWORD = random_password.password.result
  }
  networks_advanced {
    name = var.docker_network_id
    ipv4_address = var.docker_ip_address
  }
}