resource "random_password" "server" {
  length  = 48
  special = false
}

resource "random_password" "agent" {
  length  = 48
  special = false
}
