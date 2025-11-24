terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = ">= 2.9.3"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}
