resource "null_resource" "pool" {
  for_each   = { for idx, val in var.connections : idx => val }
  depends_on = [null_resource.firewall]

  triggers = {
    connection = jsonencode(each.value)
    this = jsonencode({
      name                   = "${var.name}-${each.key}"
      type                   = var.type
      version                = var.version_
      channel                = var.channel
      taints                 = var.taints
      labels                 = var.labels
      registries             = var.registries
      extra_args             = var.extra_args
      extra_envs             = var.extra_envs
      pre_create_user_data   = var.pre_create_user_data
      post_create_user_data  = var.post_create_user_data
      pre_destroy_user_data  = var.pre_destroy_user_data
      post_destroy_user_data = var.post_destroy_user_data

      join_host  = var.join_host
      join_token = var.join_token
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
    content     = templatefile("${path.module}/templates/create.sh", jsondecode(self.triggers.this))
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
