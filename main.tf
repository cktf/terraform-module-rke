terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "hashicorp/null"
      version = "3.1.0"
    }
  }
}
