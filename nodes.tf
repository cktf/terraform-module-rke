resource "null_resource" "nodes" {
  for_each   = var.nodes
  depends_on = [null_resource.this]

  triggers = {
    connection = jsonencode(each.value.connection)
    this = jsonencode({
      name       = "agent"
      type       = var.type
      channel    = var.channel
      version    = var.version_
      registries = var.registries

      taints                 = try(each.value.taints, {})
      labels                 = try(each.value.labels, {})
      extra_args             = try(each.value.extra_args, [])
      extra_envs             = try(each.value.extra_envs, {})
      pre_create_user_data   = try(each.value.pre_create_user_data, "")
      post_create_user_data  = try(each.value.post_create_user_data, "")
      pre_destroy_user_data  = try(each.value.pre_destroy_user_data, "")
      post_destroy_user_data = try(each.value.post_destroy_user_data, "")

      join_host  = local.private_alb
      join_token = random_string.agent_token.result
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
    content     = templatefile("${path.module}/templates/agent.sh", jsondecode(self.triggers.this))
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
