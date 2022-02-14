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

data "k8sbootstrap_auth" "this" {
  depends_on = [null_resource.master, null_resource.worker]

  server = "https://${coalesce(var.load_balancer, values(var.masters)[0].connection.host)}:6443"
  token  = "${random_string.token_id.result}.${random_string.token_secret.result}"
}
