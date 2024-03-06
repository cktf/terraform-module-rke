locals {
  leaders = {
    for key, val in var.servers : key => val
    if key == try(keys(var.servers)[0], null)
  }
  servers = {
    for key, val in var.servers : key => val
    if key != try(keys(var.servers)[0], null)
  }

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
  for_each   = local.leaders
  depends_on = [module.install]

  connection = each.value.connection
  create     = <<-EOF
    cat <<-EOFX | tee /etc/rancher/${var.type}/registries.yaml > /dev/null
    ${yamlencode(merge(var.registries, each.value.registries))}
    EOFX
    cat <<-EOFX | tee /etc/rancher/${var.type}/config.yaml > /dev/null
    ${yamlencode(merge(var.configs, each.value.configs, local.leader_configs))}
    EOFX
    ${each.value.pre_exec}
    systemctl restart ${var.type}-server.service || true
    ${each.value.post_exec}
  EOF
}

module "servers" {
  source     = "cktf/script/module"
  version    = "1.1.0"
  for_each   = local.servers
  depends_on = [module.leader]

  connection = each.value.connection
  create     = <<-EOF
    cat <<-EOFX | tee /etc/rancher/${var.type}/registries.yaml > /dev/null
    ${yamlencode(merge(var.registries, each.value.registries))}
    EOFX
    cat <<-EOFX | tee /etc/rancher/${var.type}/config.yaml > /dev/null
    ${yamlencode(merge(var.configs, each.value.configs, local.server_configs))}
    EOFX
    ${each.value.pre_exec}
    systemctl restart ${var.type}-server.service || true
    ${each.value.post_exec}
  EOF
}

module "agents" {
  source     = "cktf/script/module"
  version    = "1.1.0"
  for_each   = var.agents
  depends_on = [module.leader]

  connection = each.value.connection
  create     = <<-EOF
    cat <<-EOFX | tee /etc/rancher/${var.type}/registries.yaml > /dev/null
    ${yamlencode(merge(var.registries, each.value.registries))}
    EOFX
    cat <<-EOFX | tee /etc/rancher/${var.type}/config.yaml > /dev/null
    ${yamlencode(merge(var.configs, each.value.configs, local.agent_configs))}
    EOFX
    ${each.value.pre_exec}
    systemctl restart ${var.type}-agent.service || true
    ${each.value.post_exec}
  EOF
}

module "addons" {
  source     = "cktf/script/module"
  version    = "1.1.0"
  for_each   = { for key, val in var.addons : key => val if local.leaders != {} }
  depends_on = [module.leader]

  connection = try(values(local.leaders)[0].connection, null)
  create     = "echo ${base64encode(each.value)} | base64 -d > /var/lib/rancher/${var.type}/server/manifests/${each.key}.yaml"
  destroy    = "echo > /var/lib/rancher/${var.type}/server/manifests/${each.key}.yaml"
}

resource "ssh_sensitive_resource" "kubeconfig" {
  count      = (local.leaders != {}) ? 1 : 0
  depends_on = [module.leader]

  host                = try(values(local.leaders)[0].connection.host, null)
  port                = try(values(local.leaders)[0].connection.port, null)
  user                = try(values(local.leaders)[0].connection.user, null)
  password            = try(values(local.leaders)[0].connection.password, null)
  private_key         = try(values(local.leaders)[0].connection.private_key, null)
  timeout             = try(values(local.leaders)[0].connection.timeout, null)
  agent               = try(values(local.leaders)[0].connection.agent, null)
  bastion_host        = try(values(local.leaders)[0].connection.bastion_host, null)
  bastion_port        = try(values(local.leaders)[0].connection.bastion_port, null)
  bastion_user        = try(values(local.leaders)[0].connection.bastion_user, null)
  bastion_password    = try(values(local.leaders)[0].connection.bastion_password, null)
  bastion_private_key = try(values(local.leaders)[0].connection.bastion_private_key, null)

  commands = ["cat /etc/rancher/${var.type}/${var.type}.yaml"]
}
