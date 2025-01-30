terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

provider "docker" {}

# Créer l'image Docker Nginx
resource "docker_image" "ubuntu" {
  name         = "rastasheep/ubuntu-sshd:latest"
  keep_locally = false
}

# Créer un réseau Docker partagé
resource "docker_network" "shared_network1" {
  name = "shared_network1"
  driver = "bridge"
  ipam_config {
    subnet = "172.16.0.0/16"
  }
  count = var.host == "localhost" ? 1 : 0
}

resource "docker_network" "shared_network2" {
  name = "shared_network2"
  driver = "bridge"
  ipam_config {
    subnet = "172.15.0.0/16"
  }
  count = var.host == "remote_host" ? 1 : 0  
}

# Déployer les conteneurs pour localhost
resource "docker_container" "slave-1" {
  image = docker_image.ubuntu.image_id
  name  = "slave-1"
  restart="unless-stopped"
  ports {
    internal = 22
    external = 8081
  }
  networks_advanced {
    name = docker_network.shared_network2[0].name
    ipv4_address="172.15.0.11"
  }
  count = var.host == "remote_host" ? 1 : 0
}

resource "docker_container" "slave-2" {
  image = docker_image.ubuntu.image_id
  name  = "slave-2"
  restart="unless-stopped"
  ports {
    internal = 22
    external = 8082
  }
  networks_advanced {
    name = docker_network.shared_network2[0].name
    ipv4_address = "172.15.0.12"
  }
  count = var.host == "remote_host" ? 1 : 0
}

# Déployer les conteneurs pour remote_host
resource "docker_container" "slave-3" {
  image = docker_image.ubuntu.image_id
  name  = "slave-3"
  restart="unless-stopped"
  ports {
    internal = 22
    external = 8083
  }
  networks_advanced {
    name = docker_network.shared_network1[0].name
    ipv4_address= "172.16.0.13"
  }
  count = var.host == "localhost" ? 1 : 0
}

resource "docker_container" "master" {
  image = docker_image.ubuntu.image_id
  name  = "master"
  restart="unless-stopped"
  ports {
    internal = 22
    external = 8084
  }
  ports{
    internal = 54310
    external = 54310
  }
  networks_advanced {
    name = docker_network.shared_network1[0].name
    ipv4_address="172.16.0.10"
  }
  count = var.host == "localhost" ? 1 : 0
}
