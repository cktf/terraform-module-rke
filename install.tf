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
    "curl -sfL https://get.${var.type}.io | sh - && sleep 10",
    "systemctl enable ${var.type}-${each.value.exec}.service",
    "mkdir -p /etc/rancher/${var.type} /var/lib/rancher/${var.type}/${each.value.exec}/manifests",
  ])
  destroy = join("\n", [
    "/usr/local/bin/${var.type}*uninstall.sh"
  ])
}
