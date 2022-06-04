terraform {
  required_version = ">= 0.14.0"
  required_providers {}
}

module "cluster" {
  source = "./modules/cluster"

  name                   = var.name
  type                   = var.type
  version_               = var.version_
  channel                = var.channel
  taints                 = var.taints
  labels                 = var.labels
  registries             = var.registries
  connections            = var.connections
  extra_args             = var.extra_args
  extra_envs             = var.extra_envs
  pre_create_user_data   = var.pre_create_user_data
  post_create_user_data  = var.post_create_user_data
  pre_destroy_user_data  = var.pre_destroy_user_data
  post_destroy_user_data = var.post_destroy_user_data
}

module "node_pool" {
  source   = "./modules/node_pool"
  for_each = var.node_pools

  name                   = try(each.value.name, var.name)
  type                   = try(each.value.type, var.type)
  version_               = try(each.value.version_, var.version_)
  channel                = try(each.value.channel, var.channel)
  taints                 = try(each.value.taints, {})
  labels                 = try(each.value.labels, {})
  registries             = try(each.value.registries, var.registries)
  connections            = try(each.value.connections, {})
  extra_args             = try(each.value.extra_args, var.extra_args)
  extra_envs             = try(each.value.extra_envs, var.extra_envs)
  pre_create_user_data   = try(each.value.pre_create_user_data, var.pre_create_user_data)
  post_create_user_data  = try(each.value.post_create_user_data, var.post_create_user_data)
  pre_destroy_user_data  = try(each.value.pre_destroy_user_data, var.pre_destroy_user_data)
  post_destroy_user_data = try(each.value.post_destroy_user_data, var.post_destroy_user_data)

  join_host  = module.cluster.join_host
  join_token = module.cluster.join_token
}
