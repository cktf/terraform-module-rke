terraform {
  required_version = ">= 0.14.0"
  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = ">= 3.0.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0.0"
    }
    k8sbootstrap = {
      source  = "nimbolus/k8sbootstrap"
      version = ">= 0.1.2"
    }
  }
}
