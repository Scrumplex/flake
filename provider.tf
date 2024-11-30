terraform {
  required_providers {
    hetznerdns = {
      source  = "timohirt/hetznerdns"
      version = "~> 2.2.0"
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

variable "hetznerdns_token" {
  sensitive = true
}

provider "hetznerdns" {
  apitoken = var.hetznerdns_token
}
