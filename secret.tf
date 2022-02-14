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

resource "random_string" "master_token" {
  length  = 48
  special = false
}

resource "random_string" "worker_token" {
  length  = 48
  special = false
}
