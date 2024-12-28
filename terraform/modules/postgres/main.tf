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
    ip_address = var.docker_ip_address
  }
}