terraform {
  required_version = ">= 0.14.0"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
  }
}

module "cluster" {
  source = "./modules/cluster"
}

module "node_pool" {
  source   = "./modules/node_pool"
  for_each = var.node_pools


}
