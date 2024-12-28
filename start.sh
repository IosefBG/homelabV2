#!/bin/bash

# Verifică dacă git este instalat
if ! command -v git &> /dev/null; then
  echo "Eroare: git nu este instalat."
  echo "Se instalează git..."
  sudo apt-get update && sudo apt-get install -y git
fi

# Clonează proiectul de pe GitHub
git clone https://github.com/IosefBG/homelabV2

# Navighează la directorul proiectului
cd homelabV2

# Verifică dacă wget este instalat
if ! command -v wget &> /dev/null; then
  echo "Eroare: wget nu este instalat."
  echo "Se instalează wget..."
  sudo apt-get update && sudo apt-get install -y wget
fi

# Instalează dependențele pentru Docker (doar dacă nu sunt deja instalate)
if ! command -v docker &> /dev/null; then
  sudo apt-get update
  sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

  # Adaugă cheia GPG oficială pentru Docker
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

  # Adaugă repository-ul Docker
  sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"

  # Instalează Docker Engine și Docker Compose
  sudo apt-get update
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

  # Verifică dacă Docker a fost instalat corect
  if ! command -v docker &> /dev/null; then
    echo "Eroare: Docker nu a putut fi instalat."
    exit 1  # Ieșire doar dacă instalarea eșuează
  fi
fi


# Instalează Terraform (doar dacă nu este deja instalat)
if ! command -v terraform &> /dev/null; then
    wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update && sudo apt install terraform

  # Verifică dacă Terraform a fost instalat corect
  if ! command -v terraform &> /dev/null; then
    echo "Eroare: Terraform nu a putut fi instalat."
    exit 1  # Ieșire doar dacă instalarea eșuează
  fi
fi

cd terraform

# Inițializează Terraform (doar dacă nu este deja inițializat)
if [[ ! -f .terraform/ ]]; then
  terraform init
fi

# Rulează Terraform
terraform apply

# Configurează Vault (doar dacă nu este deja configurat)
if [[ ! -f vault_keys.txt ]]; then
  chmod +x scripts/setup-vault.sh
  ./scripts/setup-vault.sh
fi