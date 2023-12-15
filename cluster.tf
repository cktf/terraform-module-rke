module "install" {
  source  = "cktf/script/module"
  version = "1.1.0"
  for_each = merge(
    { for key, val in var.servers : "server_${key}" => merge(val, { exec = "server" }) },
    { for key, val in var.agents : "agent_${key}" => merge(val, { exec = "agent" }) }
  )

  connection = each.value.connection
  create = join("\n", [
    "export INSTALL_${upper(var.type)}_SKIP_START=true",
    "export INSTALL_${upper(var.type)}_NAME=${each.value.exec}",
    "export INSTALL_${upper(var.type)}_EXEC=${each.value.exec}",
    "export INSTALL_${upper(var.type)}_CHANNEL=${each.value.channel != null ? each.value.channel : var.channel}",
    "export INSTALL_${upper(var.type)}_VERSION=${each.value.version != null ? each.value.version : var.version_}",
    "curl -sfL https://get.${var.type}.io | sh -",
    "systemctl enable ${var.type}-${each.value.exec}.service",
    "mkdir -p /etc/rancher/${var.type} /var/lib/rancher/${var.type}/${each.value.exec}/manifests",
  ])
  destroy = join("\n", [
    "/usr/local/bin/${var.type}*uninstall.sh"
  ])
}

module "leader" {
  source     = "cktf/script/module"
  version    = "1.1.0"
  depends_on = [module.install]
  for_each = {
    for key, val in var.servers : key => merge(val, {
      registries = yamlencode(merge(var.registries, val.registries))
      configs = yamlencode(merge(var.configs, val.configs, {
        "write-kubeconfig-mode" = "0644"
        "agent-token"           = random_password.agent.result
        "token"                 = random_password.server.result
        "cluster-init"          = var.external_db == "" ? "true" : "false"
        "datastore-endpoint"    = var.external_db
      }))
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
    systemctl restart ${var.type}-server.service
  EOF
}

module "servers" {
  source     = "cktf/script/module"
  version    = "1.1.0"
  depends_on = [module.leader]
  for_each = {
    for key, val in var.servers : key => merge(val, {
      registries = yamlencode(merge(var.registries, val.registries))
      configs = yamlencode(merge(var.configs, val.configs, {
        "write-kubeconfig-mode" = "0644"
        "agent-token"           = random_password.agent.result
        "token"                 = random_password.server.result
        "server"                = var.external_db == "" ? "https://${var.server_ip}:${local.port}" : ""
        "datastore-endpoint"    = var.external_db
      }))
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
    systemctl restart ${var.type}-server.service
  EOF
}

module "agents" {
  source     = "cktf/script/module"
  version    = "1.1.0"
  depends_on = [module.servers]
  for_each = {
    for key, val in var.agents : key => merge(val, {
      registries = yamlencode(merge(var.registries, val.registries))
      configs = yamlencode(merge(var.configs, val.configs, {
        "server" = "https://${var.server_ip}:${local.port}"
        "token"  = random_password.agent.result
      }))
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
    systemctl restart ${var.type}-server.service
  EOF
}

module "addons" {
  source     = "cktf/script/module"
  version    = "1.1.0"
  for_each   = var.addons
  depends_on = [module.servers]

  connection = var.servers[local.leader].connection
  create     = "echo ${base64encode(each.value)} | base64 -d > /var/lib/rancher/${var.type}/server/manifests/${each.key}.yaml"
  destroy    = "echo > /var/lib/rancher/${var.type}/server/manifests/${each.key}.yaml"
}

resource "ssh_sensitive_resource" "kubeconfig" {
  depends_on = [module.servers]

  host         = try(var.servers[local.leader].connection.host, null)
  port         = try(var.servers[local.leader].connection.port, null)
  user         = try(var.servers[local.leader].connection.user, null)
  password     = try(var.servers[local.leader].connection.password, null)
  timeout      = try(var.servers[local.leader].connection.timeout, null)
  private_key  = try(var.servers[local.leader].connection.private_key, null)
  agent        = try(var.servers[local.leader].connection.agent, null)
  bastion_host = try(var.servers[local.leader].connection.bastion_host, null)
  bastion_port = try(var.servers[local.leader].connection.bastion_port, null)

  commands = ["cat /etc/rancher/${var.type}/${var.type}.yaml"]
}
