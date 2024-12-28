#!/bin/bash

# Așteaptă ca Vault să pornească
while ! curl -s http://192.168.1.101:8200/v1/sys/health | grep -q "sealed=false"; do
  sleep 1
done

# Inițializează Vault și exportă cheile de unseal
vault operator init -key-shares=1 -key-threshold=1 > vault_keys.txt

# Extrage token-ul root și cheile de unseal
export VAULT_TOKEN=$(grep "Initial Root Token" vault_keys.txt | awk '{print $NF}')
export VAULT_UNSEAL_KEY=$(grep "Unseal Key 1" vault_keys.txt | awk '{print $NF}')

# Desigilează Vault
vault operator unseal $VAULT_UNSEAL_KEY

# Configurează backend-ul PostgreSQL
vault secrets enable database

# Configurează conexiunea la PostgreSQL
vault write database/config/postgres \
  plugin_name=postgresql-database-plugin \
  allowed_roles=vault \
  connection_url="${DB_ENDPOINT}?sslmode=disable"

# Creează un rol Vault pentru a genera credențiale dinamice
vault write database/roles/vault \
  db_name=postgres \
  creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';" \
  default_ttl="1h" \
  max_ttl="24h"

# Creează folderul "homelab"
vault kv put secret/homelab

# Adaugă secretele pentru PostgreSQL
vault kv put secret/homelab/postgres \
  username="vault" \
  password=$(grep "password" terraform/modules/postgres/outputs.tf | awk '{print $NF}') \
  ip="192.168.1.100" 

# Adaugă secretele pentru Nginx Proxy Manager
vault kv put secret/homelab/nginx-proxy-manager \
  username="admin" \
  password="changeme" # Înlocuiește cu parola dorită
  ip="192.168.1.102" 

# Adaugă secretele pentru Portainer
vault kv put secret/homelab/portainer \
  ip="192.168.1.103" 

# Adaugă secretele pentru pgAdmin
vault kv put secret/homelab/pgadmin \
  username="admin@admin.com" \
  password="admin" # Înlocuiește cu parola dorită
  ip="192.168.1.104"