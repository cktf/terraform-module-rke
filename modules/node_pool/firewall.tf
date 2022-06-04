resource "null_resource" "firewall" {
  for_each = { for idx, val in var.connections : idx => val }

  triggers = {
    connection = jsonencode(each.value)
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

  provisioner "remote-exec" {
    when = create
    inline = [
      "echo '${jsondecode(self.triggers.connection).password}' | sudo -S -v",
      "sudo ufw allow http",
      "sudo ufw allow https",
      "sudo ufw allow 2379",
      "sudo ufw allow 2380",
      "sudo ufw allow 6443",
      "sudo ufw allow 9345",
      "sudo ufw allow 10250",
      "sudo ufw allow 179",
      "sudo ufw allow 4789",
      "sudo ufw allow 5473",
      "sudo ufw --force enable",
    ]
  }

  provisioner "remote-exec" {
    when = destroy
    inline = [
      "echo '${jsondecode(self.triggers.connection).password}' | sudo -S -v",
      "sudo ufw disable",
      "sudo ufw deny http",
      "sudo ufw deny https",
      "sudo ufw deny 2379",
      "sudo ufw deny 2380",
      "sudo ufw deny 6443",
      "sudo ufw deny 9345",
      "sudo ufw deny 10250",
      "sudo ufw deny 179",
      "sudo ufw deny 4789",
      "sudo ufw deny 5473",
    ]
  }
}
