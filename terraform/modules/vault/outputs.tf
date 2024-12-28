output "vault_address" {
  value = "http://${docker_container.vault.ip_address}:8200"
}