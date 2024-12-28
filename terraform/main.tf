resource "docker_network" "homelab_network" {
  name = "homelab-network"
  ipam_config {
    subnet = "192.168.1.0/24"
  }
}

module "postgres" {
  source = "./modules/postgres"
  docker_network_id = docker_network.homelab_network.id
  docker_ip_address = "192.168.1.100"
}

module "vault" {
  source = "./modules/vault"
  docker_network_id = docker_network.homelab_network.id
  docker_ip_address = "192.168.1.101"
}

module "nginx-proxy-manager" {
  source = "./modules/nginx-proxy-manager"
  docker_network_id = docker_network.homelab_network.id
  docker_ip_address = "192.168.1.102"
}

module "portainer" {
  source = "./modules/portainer"
  docker_network_id = docker_network.homelab_network.id
  docker_ip_address = "192.168.1.103"
}

module "pgadmin" {
  source = "./modules/pgadmin"
  docker_network_id = docker_network.homelab_network.id
  docker_ip_address = "192.168.1.104"
}