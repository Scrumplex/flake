terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.70.1"
    }
  }


  cloud {
    hostname     = "app.terraform.io"
    organization = "scrumplex"

    workspaces {
      name = "flake"
    }
  }
}

variable "hcloud_token" {
  sensitive = true
}

provider "hcloud" {
  token = var.hcloud_token
}
