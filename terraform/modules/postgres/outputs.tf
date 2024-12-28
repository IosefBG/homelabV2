output "db_endpoint" {
  value = "postgresql://${var.db_username}:${random_password.password.result}@${docker_container.postgres.ip_address}:5432/${postgresql_database.main.name}"
  sensitive = true
}