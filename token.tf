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
  depends_on = [null_resource.this]

  server = "https://${local.public_alb}:6443"
  token  = "${random_string.token_id.result}.${random_string.token_secret.result}"
}
