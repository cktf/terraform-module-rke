locals {
  leader = var.masters[keys(var.masters)[0]]
  servers = merge(
    { for key, val in var.masters : "master_${key}" => merge(val, {
      exec       = "server"
      channel    = try(val.channel, var.channel)
      version    = try(val.version, var.version_)
      registries = base64encode(yamlencode(merge(var.registries, try(val.registries, {}))))
      configs = base64encode(yamlencode(merge(var.configs, try(val.configs, {}), {
        "write-kubeconfig-mode" = "0644"
        "cluster-init"          = (key == keys(var.masters)[0] ? "true" : "false")
        "server"                = "https://${var.server_ip}:6443"
        "token"                 = random_password.server.result
        "agent-token"           = random_password.agent.result
      })))
    }) },
    { for key, val in var.workers : "worker_${key}" => merge(val, {
      exec       = "agent"
      channel    = try(val.channel, var.channel)
      version    = try(val.version, var.version_)
      registries = base64encode(yamlencode(merge(var.registries, try(val.registries, {}))))
      configs = base64encode(yamlencode(merge(var.configs, try(val.configs, {}), {
        "server"      = "https://${var.server_ip}:6443"
        "agent-token" = random_password.agent.result
      })))
    }) }
  )
}

module "install" {
  source   = "cktf/script/module"
  version  = "1.0.1"
  for_each = local.servers

  connection = each.value.connection
  create = join("\n", [
    "INSTALL_${upper(var.type)}_SKIP_START=true",
    "INSTALL_${upper(var.type)}_NAME=${each.value.exec}",
    "INSTALL_${upper(var.type)}_EXEC=${each.value.exec}",
    "INSTALL_${upper(var.type)}_CHANNEL=${each.value.channel}",
    "INSTALL_${upper(var.type)}_VERSION=${each.value.version}",
    "mkdir -p /etc/rancher/${var.type} /var/lib/rancher/${var.type}/${each.value.exec}/manifests",
    "curl -sfL https://get.${var.type}.io | sh -"
  ])
  destroy = join("\n", [
    "/usr/local/bin/${var.type}-${each.value.exec}-uninstall.sh"
  ])
}

module "configs" {
  source     = "cktf/script/module"
  version    = "1.0.1"
  for_each   = local.servers
  depends_on = [module.install]

  connection = each.value.connection
  create = join("\n", [
    "echo ${each.value.registries} | base64 -d > /etc/rancher/${var.type}/registries.yaml",
    "echo ${each.value.configs} | base64 -d > /etc/rancher/${var.type}/config.yaml",
    "systemctl restart ${var.type}-${each.value.exec}.service"
  ])
}

module "addons" {
  source     = "cktf/script/module"
  version    = "1.0.1"
  for_each   = var.addons
  depends_on = [module.configs]

  connection = local.leader
  create     = "echo ${base64encode(each.value)} | base64 -d > /var/lib/rancher/${var.type}/server/manifests/${each.key}.yaml"
  destroy    = "echo > /var/lib/rancher/${var.type}/server/manifests/${each.key}.yaml"
}

resource "ssh_sensitive_resource" "kubeconfig" {
  depends_on = [module.configs]

  host         = try(local.leader.connection.host, null)
  port         = try(local.leader.connection.port, null)
  user         = try(local.leader.connection.user, null)
  password     = try(local.leader.connection.password, null)
  timeout      = try(local.leader.connection.timeout, null)
  private_key  = try(local.leader.connection.private_key, null)
  agent        = try(local.leader.connection.agent, null)
  bastion_host = try(local.leader.connection.bastion_host, null)
  bastion_port = try(local.leader.connection.bastion_port, null)

  commands = ["cat /etc/rancher/${var.type}/${var.type}.yaml"]
}
