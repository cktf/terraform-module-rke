resource "null_resource" "master_firewall" {
  for_each = var.masters

  triggers = each.value
  connection {
    type                = try(self.triggers.connection.type, null)
    host                = try(self.triggers.connection.host, null)
    port                = try(self.triggers.connection.port, null)
    user                = try(self.triggers.connection.user, null)
    password            = try(self.triggers.connection.password, null)
    timeout             = try(self.triggers.connection.timeout, null)
    script_path         = try(self.triggers.connection.script_path, null)
    private_key         = try(self.triggers.connection.private_key, null)
    certificate         = try(self.triggers.connection.certificate, null)
    agent               = try(self.triggers.connection.agent, null)
    agent_identity      = try(self.triggers.connection.agent_identity, null)
    host_key            = try(self.triggers.connection.host_key, null)
    https               = try(self.triggers.connection.https, null)
    insecure            = try(self.triggers.connection.insecure, null)
    use_ntlm            = try(self.triggers.connection.use_ntlm, null)
    cacert              = try(self.triggers.connection.cacert, null)
    bastion_host        = try(self.triggers.connection.bastion_host, null)
    bastion_host_key    = try(self.triggers.connection.bastion_host_key, null)
    bastion_port        = try(self.triggers.connection.bastion_port, null)
    bastion_user        = try(self.triggers.connection.bastion_user, null)
    bastion_password    = try(self.triggers.connection.bastion_password, null)
    bastion_private_key = try(self.triggers.connection.bastion_private_key, null)
    bastion_certificate = try(self.triggers.connection.bastion_certificate, null)
  }

  provisioner "remote-exec" {
    when = create
    inline = [
      "sudo ufw allow ssh",
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
      "sudo ufw disable",
      "sudo ufw deny ssh",
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

resource "null_resource" "master" {
  for_each   = var.masters
  depends_on = [null_resource.master_firewall]

  triggers = each.value
  connection {
    type                = try(self.triggers.connection.type, null)
    host                = try(self.triggers.connection.host, null)
    port                = try(self.triggers.connection.port, null)
    user                = try(self.triggers.connection.user, null)
    password            = try(self.triggers.connection.password, null)
    timeout             = try(self.triggers.connection.timeout, null)
    script_path         = try(self.triggers.connection.script_path, null)
    private_key         = try(self.triggers.connection.private_key, null)
    certificate         = try(self.triggers.connection.certificate, null)
    agent               = try(self.triggers.connection.agent, null)
    agent_identity      = try(self.triggers.connection.agent_identity, null)
    host_key            = try(self.triggers.connection.host_key, null)
    https               = try(self.triggers.connection.https, null)
    insecure            = try(self.triggers.connection.insecure, null)
    use_ntlm            = try(self.triggers.connection.use_ntlm, null)
    cacert              = try(self.triggers.connection.cacert, null)
    bastion_host        = try(self.triggers.connection.bastion_host, null)
    bastion_host_key    = try(self.triggers.connection.bastion_host_key, null)
    bastion_port        = try(self.triggers.connection.bastion_port, null)
    bastion_user        = try(self.triggers.connection.bastion_user, null)
    bastion_password    = try(self.triggers.connection.bastion_password, null)
    bastion_private_key = try(self.triggers.connection.bastion_private_key, null)
    bastion_certificate = try(self.triggers.connection.bastion_certificate, null)
  }

  provisioner "file" {
    when        = create
    content     = templatefile("${path.module}/config/master.create.sh", {})
    destination = "/tmp/script.sh"
  }
  provisioner "remote-exec" {
    when = create
    inline = [
      "chmod +x /tmp/script.sh",
      "echo ${self.triggers.password} | sudo -S /tmp/script.sh"
    ]
  }

  provisioner "file" {
    when        = destroy
    content     = templatefile("${path.module}/config/master.destroy.sh", {})
    destination = "/tmp/script.sh"
  }
  provisioner "remote-exec" {
    when = destroy
    inline = [
      "chmod +x /tmp/script.sh",
      "echo ${self.triggers.password} | sudo -S /tmp/script.sh"
    ]
  }
}
