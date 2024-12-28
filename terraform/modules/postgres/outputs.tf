output "db_endpoint" {
  value = "postgresql://${postgresql_user.vault_user.name}:${random_password.password.result}@${docker_container.postgres.ip_address}:5432/${postgresql_database.main.name}"
  sensitive = true
}