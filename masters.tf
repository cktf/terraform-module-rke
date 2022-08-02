locals {
  private_alb = try(var.private_alb, values(var.masters)[0].connection.host)
  public_alb  = try(var.public_alb, values(var.masters)[0].connection.host)
  bootstrap_file = templatefile("${path.module}/templates/manifests/bootstrap.yml", {
    token_id     = random_string.token_id.result
    token_secret = random_string.token_secret.result
  })
}

resource "null_resource" "this" {
  for_each = var.masters

  triggers = {
    connection = jsonencode(each.value.connection)
    this = jsonencode({
      name       = "${var.name}-master-${each.key}"
      type       = var.type
      channel    = var.channel
      version    = var.version_
      registries = var.registries
      pods_cidr  = var.pods_cidr

      taints                = try(each.value.taints, {})
      labels                = try(each.value.labels, {})
      extra_args            = try(each.value.extra_args, [])
      extra_envs            = try(each.value.extra_envs, {})
      pre_create_user_data  = try(each.value.pre_create_user_data, "")
      post_create_user_data = try(each.value.post_create_user_data, "")

      leader        = (each.key == keys(var.masters)[0])
      private_ip    = local.private_alb
      public_ip     = local.public_alb
      cluster_token = random_string.cluster_token.result
      agent_token   = random_string.agent_token.result

      bootstrap_file = local.bootstrap_file
    })
  }

  connection {
    type                = try(jsondecode(self.triggers.connection).type, null)
    host                = try(jsondecode(self.triggers.connection).host, null)
    port                = try(jsondecode(self.triggers.connection).port, null)
    user                = try(jsondecode(self.triggers.connection).user, null)
    password            = try(jsondecode(self.triggers.connection).password, null)
    timeout             = try(jsondecode(self.triggers.connection).timeout, null)
    script_path         = try(jsondecode(self.triggers.connection).script_path, null)
    private_key         = try(jsondecode(self.triggers.connection).private_key, null)
    certificate         = try(jsondecode(self.triggers.connection).certificate, null)
    agent               = try(jsondecode(self.triggers.connection).agent, null)
    agent_identity      = try(jsondecode(self.triggers.connection).agent_identity, null)
    host_key            = try(jsondecode(self.triggers.connection).host_key, null)
    https               = try(jsondecode(self.triggers.connection).https, null)
    insecure            = try(jsondecode(self.triggers.connection).insecure, null)
    use_ntlm            = try(jsondecode(self.triggers.connection).use_ntlm, null)
    cacert              = try(jsondecode(self.triggers.connection).cacert, null)
    bastion_host        = try(jsondecode(self.triggers.connection).bastion_host, null)
    bastion_host_key    = try(jsondecode(self.triggers.connection).bastion_host_key, null)
    bastion_port        = try(jsondecode(self.triggers.connection).bastion_port, null)
    bastion_user        = try(jsondecode(self.triggers.connection).bastion_user, null)
    bastion_password    = try(jsondecode(self.triggers.connection).bastion_password, null)
    bastion_private_key = try(jsondecode(self.triggers.connection).bastion_private_key, null)
    bastion_certificate = try(jsondecode(self.triggers.connection).bastion_certificate, null)
  }

  provisioner "file" {
    when        = create
    destination = "/tmp/script.sh"
    content     = templatefile("${path.module}/templates/server.sh", jsondecode(self.triggers.this))
  }
  provisioner "remote-exec" {
    when = create
    inline = [
      "echo '${jsondecode(self.triggers.connection).password}' | sudo -S -v",
      "sudo chmod +x /tmp/script.sh",
      "sudo /tmp/script.sh",
    ]
  }

  provisioner "file" {
    when        = destroy
    destination = "/tmp/script.sh"
    content     = templatefile("${path.module}/templates/destroy.sh", jsondecode(self.triggers.this))
  }
  provisioner "remote-exec" {
    when = destroy
    inline = [
      "echo '${jsondecode(self.triggers.connection).password}' | sudo -S -v",
      "sudo chmod +x /tmp/script.sh",
      "sudo /tmp/script.sh",
    ]
  }
}
