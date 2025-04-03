terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.50.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_kubernetes_cluster" "k8s" {
  name   = "${var.k8s_name}-${terraform.workspace}"
  region = var.k8s_region
  version = var.k8s_version

  node_pool {
    name       = var.worker_pool
    size       = var.k8s_worker_size
    node_count = var.node_count

  }

}

