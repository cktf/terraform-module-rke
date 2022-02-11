resource "random_password" "master_secret" {
  length  = 48
  special = false
}

resource "random_password" "worker_secret" {
  length  = 48
  special = false
}
