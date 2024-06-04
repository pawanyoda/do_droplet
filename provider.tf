terraform {
  required_version = ">= 1.8"
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.8.0"
    }
    ct = {
      source  = "poseidon/ct"
      version = "0.13.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.1.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
#    spaces_access_id =  var.tf_spaces_access_id
#    spaces_secret_key = var.tf_spaces_secret_id
}

provider "tfe" {
  hostname = "app.terraform.io"
  token    = var.tfe_token
}


