terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "2.9.3"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.10"
    }
  }
}

provider "linode" {
  token = var.linode_token
}

provider "kubernetes" {
  host                   = yamldecode(base64decode(module.lke.kubeconfig)).clusters[0].cluster.server
  token                  = yamldecode(base64decode(module.lke.kubeconfig)).users[0].user.token
  cluster_ca_certificate = base64decode(yamldecode(base64decode(module.lke.kubeconfig)).clusters[0].cluster["certificate-authority-data"])
}

provider "helm" {
  kubernetes {
    host                   = yamldecode(base64decode(module.lke.kubeconfig)).clusters[0].cluster.server
    token                  = yamldecode(base64decode(module.lke.kubeconfig)).users[0].user.token
    cluster_ca_certificate = base64decode(yamldecode(base64decode(module.lke.kubeconfig)).clusters[0].cluster["certificate-authority-data"])
  }
}
