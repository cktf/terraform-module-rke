terraform {
  required_version = ">= 0.14.0"
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "3.1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
    k8sbootstrap = {
      source  = "nimbolus/k8sbootstrap"
      version = "0.1.2"
    }
  }
}

resource "random_string" "token_id" {
  length  = 6
  upper   = false
  special = false
}

resource "random_string" "token_secret" {
  length  = 16
  upper   = false
  special = false
}

resource "random_string" "cluster_token" {
  length  = 48
  special = false
}

resource "random_string" "agent_token" {
  length  = 48
  special = false
}

data "k8sbootstrap_auth" "this" {
  depends_on = [null_resource.server]

  server = "https://${var.connections[0].host}:6443"
  token  = "${random_string.token_id.result}.${random_string.token_secret.result}"
}
