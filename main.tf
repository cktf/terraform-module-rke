terraform {
  required_version = ">= 0.14.0"
  required_providers {
    ssh = {
      source  = "loafoe/ssh"
      version = ">= 2.2.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0.0"
    }
  }
}
