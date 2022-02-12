resource "random_password" "master_token" {
  length  = 48
  special = false
}

resource "random_password" "worker_token" {
  length  = 48
  special = false
}
