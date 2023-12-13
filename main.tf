terraform {
  required_version = ">= 1.4.0"
  required_providers {
    ssh = {
      source  = "loafoe/ssh"
      version = ">= 2.2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0.0"
    }
  }
}
