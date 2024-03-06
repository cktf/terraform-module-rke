terraform {
  required_version = ">= 1.4.0"
  required_providers {
    ssh = {
      source  = "loafoe/ssh"
      version = ">= 2.2.0"
    }
  }
}

locals {
  port   = var.type == "k3s" ? "6443" : "9345"
  leader = keys(var.servers)[0]
}
