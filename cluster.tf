locals {
  leader_configs = {
    "write-kubeconfig-mode" = "0644"
    "agent-token"           = var.agent_token
    "token"                 = var.server_token
    "cluster-init"          = var.external_db == "" ? "true" : "false"
    "datastore-endpoint"    = var.external_db
  }
  server_configs = {
    "write-kubeconfig-mode" = "0644"
    "agent-token"           = var.agent_token
    "token"                 = var.server_token
    "server"                = var.external_db == "" ? "https://${var.server_ip}:${local.port}" : ""
    "datastore-endpoint"    = var.external_db
  }
  agent_configs = {
    "server" = "https://${var.server_ip}:${local.port}"
    "token"  = var.agent_token
  }
}

module "leader" {
  source     = "cktf/script/module"
  version    = "1.1.0"
  depends_on = [module.install]
  for_each = {
    for key, val in var.servers : key => merge(val, {
      registries = yamlencode(merge(var.registries, val.registries))
      configs    = yamlencode(merge(var.configs, val.configs, local.leader_configs))
    })
    if key == local.leader
  }

  connection = each.value.connection
  create     = <<-EOF
    cat <<-EOFX | tee /etc/rancher/${var.type}/registries.yaml > /dev/null
    ${each.value.registries}
    EOFX
    cat <<-EOFX | tee /etc/rancher/${var.type}/config.yaml > /dev/null
    ${each.value.configs}
    EOFX
    ${each.value.pre_exec}
    systemctl restart ${var.type}-server.service || true
    ${each.value.post_exec}
  EOF
}

module "servers" {
  source     = "cktf/script/module"
  version    = "1.1.0"
  depends_on = [module.leader]
  for_each = {
    for key, val in var.servers : key => merge(val, {
      registries = yamlencode(merge(var.registries, val.registries))
      configs    = yamlencode(merge(var.configs, val.configs, local.server_configs))
    })
    if key != local.leader
  }

  connection = each.value.connection
  create     = <<-EOF
    cat <<-EOFX | tee /etc/rancher/${var.type}/registries.yaml > /dev/null
    ${each.value.registries}
    EOFX
    cat <<-EOFX | tee /etc/rancher/${var.type}/config.yaml > /dev/null
    ${each.value.configs}
    EOFX
    ${each.value.pre_exec}
    systemctl restart ${var.type}-server.service || true
    ${each.value.post_exec}
  EOF
}

module "agents" {
  source     = "cktf/script/module"
  version    = "1.1.0"
  depends_on = [module.leader]
  for_each = {
    for key, val in var.agents : key => merge(val, {
      registries = yamlencode(merge(var.registries, val.registries))
      configs    = yamlencode(merge(var.configs, val.configs, local.agent_configs))
    })
  }

  connection = each.value.connection
  create     = <<-EOF
    cat <<-EOFX | tee /etc/rancher/${var.type}/registries.yaml > /dev/null
    ${each.value.registries}
    EOFX
    cat <<-EOFX | tee /etc/rancher/${var.type}/config.yaml > /dev/null
    ${each.value.configs}
    EOFX
    ${each.value.pre_exec}
    systemctl restart ${var.type}-agent.service || true
    ${each.value.post_exec}
  EOF
}

module "addons" {
  source     = "cktf/script/module"
  version    = "1.1.0"
  for_each   = var.addons
  depends_on = [module.leader]

  connection = var.servers[local.leader].connection
  create     = "echo ${base64encode(each.value)} | base64 -d > /var/lib/rancher/${var.type}/server/manifests/${each.key}.yaml"
  destroy    = "echo > /var/lib/rancher/${var.type}/server/manifests/${each.key}.yaml"
}

resource "ssh_sensitive_resource" "kubeconfig" {
  depends_on = [module.leader]

  host                = try(var.servers[local.leader].connection.host, null)
  port                = try(var.servers[local.leader].connection.port, null)
  user                = try(var.servers[local.leader].connection.user, null)
  password            = try(var.servers[local.leader].connection.password, null)
  private_key         = try(var.servers[local.leader].connection.private_key, null)
  timeout             = try(var.servers[local.leader].connection.timeout, null)
  agent               = try(var.servers[local.leader].connection.agent, null)
  bastion_host        = try(var.servers[local.leader].connection.bastion_host, null)
  bastion_port        = try(var.servers[local.leader].connection.bastion_port, null)
  bastion_user        = try(var.servers[local.leader].connection.bastion_user, null)
  bastion_password    = try(var.servers[local.leader].connection.bastion_password, null)
  bastion_private_key = try(var.servers[local.leader].connection.bastion_private_key, null)

  commands = ["cat /etc/rancher/${var.type}/${var.type}.yaml"]
}
