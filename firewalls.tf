resource "null_resource" "master_firewalls" {
  for_each = var.master_nodes

  triggers = {
    this = jsonencode({
      node = {
        connection = each.value.connection
      }
    })
  }
  connection {
    type                = try(jsondecode(self.triggers.this).node.connection.type, null)
    host                = try(jsondecode(self.triggers.this).node.connection.host, null)
    port                = try(jsondecode(self.triggers.this).node.connection.port, null)
    user                = try(jsondecode(self.triggers.this).node.connection.user, null)
    password            = try(jsondecode(self.triggers.this).node.connection.password, null)
    timeout             = try(jsondecode(self.triggers.this).node.connection.timeout, null)
    script_path         = try(jsondecode(self.triggers.this).node.connection.script_path, null)
    private_key         = try(jsondecode(self.triggers.this).node.connection.private_key, null)
    certificate         = try(jsondecode(self.triggers.this).node.connection.certificate, null)
    agent               = try(jsondecode(self.triggers.this).node.connection.agent, null)
    agent_identity      = try(jsondecode(self.triggers.this).node.connection.agent_identity, null)
    host_key            = try(jsondecode(self.triggers.this).node.connection.host_key, null)
    https               = try(jsondecode(self.triggers.this).node.connection.https, null)
    insecure            = try(jsondecode(self.triggers.this).node.connection.insecure, null)
    use_ntlm            = try(jsondecode(self.triggers.this).node.connection.use_ntlm, null)
    cacert              = try(jsondecode(self.triggers.this).node.connection.cacert, null)
    bastion_host        = try(jsondecode(self.triggers.this).node.connection.bastion_host, null)
    bastion_host_key    = try(jsondecode(self.triggers.this).node.connection.bastion_host_key, null)
    bastion_port        = try(jsondecode(self.triggers.this).node.connection.bastion_port, null)
    bastion_user        = try(jsondecode(self.triggers.this).node.connection.bastion_user, null)
    bastion_password    = try(jsondecode(self.triggers.this).node.connection.bastion_password, null)
    bastion_private_key = try(jsondecode(self.triggers.this).node.connection.bastion_private_key, null)
    bastion_certificate = try(jsondecode(self.triggers.this).node.connection.bastion_certificate, null)
  }

  provisioner "remote-exec" {
    when = create
    inline = [<<-EOF
        echo "${jsondecode(self.triggers.this).node.connection.password}" | sudo -S -v
        sudo ufw allow http
        sudo ufw allow https
        sudo ufw allow 2379
        sudo ufw allow 2380
        sudo ufw allow 6443
        sudo ufw allow 9345
        sudo ufw allow 10250
        sudo ufw allow 179
        sudo ufw allow 4789
        sudo ufw allow 5473
        sudo ufw --force enable
    EOF
    ]
  }
  provisioner "remote-exec" {
    when = destroy
    inline = [<<-EOF
        echo "${jsondecode(self.triggers.this).node.connection.password}" | sudo -S -v
        sudo ufw disable
        sudo ufw deny http
        sudo ufw deny https
        sudo ufw deny 2379
        sudo ufw deny 2380
        sudo ufw deny 6443
        sudo ufw deny 9345
        sudo ufw deny 10250
        sudo ufw deny 179
        sudo ufw deny 4789
        sudo ufw deny 5473
    EOF
    ]
  }
}

resource "null_resource" "worker_firewalls" {
  for_each = var.worker_nodes

  triggers = {
    this = jsonencode({
      node = {
        connection = each.value.connection
      }
    })
  }
  connection {
    type                = try(jsondecode(self.triggers.this).node.connection.type, null)
    host                = try(jsondecode(self.triggers.this).node.connection.host, null)
    port                = try(jsondecode(self.triggers.this).node.connection.port, null)
    user                = try(jsondecode(self.triggers.this).node.connection.user, null)
    password            = try(jsondecode(self.triggers.this).node.connection.password, null)
    timeout             = try(jsondecode(self.triggers.this).node.connection.timeout, null)
    script_path         = try(jsondecode(self.triggers.this).node.connection.script_path, null)
    private_key         = try(jsondecode(self.triggers.this).node.connection.private_key, null)
    certificate         = try(jsondecode(self.triggers.this).node.connection.certificate, null)
    agent               = try(jsondecode(self.triggers.this).node.connection.agent, null)
    agent_identity      = try(jsondecode(self.triggers.this).node.connection.agent_identity, null)
    host_key            = try(jsondecode(self.triggers.this).node.connection.host_key, null)
    https               = try(jsondecode(self.triggers.this).node.connection.https, null)
    insecure            = try(jsondecode(self.triggers.this).node.connection.insecure, null)
    use_ntlm            = try(jsondecode(self.triggers.this).node.connection.use_ntlm, null)
    cacert              = try(jsondecode(self.triggers.this).node.connection.cacert, null)
    bastion_host        = try(jsondecode(self.triggers.this).node.connection.bastion_host, null)
    bastion_host_key    = try(jsondecode(self.triggers.this).node.connection.bastion_host_key, null)
    bastion_port        = try(jsondecode(self.triggers.this).node.connection.bastion_port, null)
    bastion_user        = try(jsondecode(self.triggers.this).node.connection.bastion_user, null)
    bastion_password    = try(jsondecode(self.triggers.this).node.connection.bastion_password, null)
    bastion_private_key = try(jsondecode(self.triggers.this).node.connection.bastion_private_key, null)
    bastion_certificate = try(jsondecode(self.triggers.this).node.connection.bastion_certificate, null)
  }

  provisioner "remote-exec" {
    when = create
    inline = [<<-EOF
        echo "${jsondecode(self.triggers.this).node.connection.password}" | sudo -S -v
        sudo ufw allow http
        sudo ufw allow https
        sudo ufw allow 2379
        sudo ufw allow 2380
        sudo ufw allow 6443
        sudo ufw allow 9345
        sudo ufw allow 10250
        sudo ufw allow 179
        sudo ufw allow 4789
        sudo ufw allow 5473
        sudo ufw --force enable
    EOF
    ]
  }
  provisioner "remote-exec" {
    when = destroy
    inline = [<<-EOF
        echo "${jsondecode(self.triggers.this).node.connection.password}" | sudo -S -v
        sudo ufw disable
        sudo ufw deny http
        sudo ufw deny https
        sudo ufw deny 2379
        sudo ufw deny 2380
        sudo ufw deny 6443
        sudo ufw deny 9345
        sudo ufw deny 10250
        sudo ufw deny 179
        sudo ufw deny 4789
        sudo ufw deny 5473
    EOF
    ]
  }
}
