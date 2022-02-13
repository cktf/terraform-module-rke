resource "random_password" "master_token" {
  length  = 48
  special = false
}

resource "random_password" "worker_token" {
  length  = 48
  special = false
}

resource "random_password" "token_id" {
  length  = 6
  upper   = false
  special = false
}

resource "random_password" "token_secret" {
  length  = 16
  upper   = false
  special = false
}
