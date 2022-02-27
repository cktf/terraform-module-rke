resource "null_resource" "master_nodes" {
  for_each   = var.master_nodes
  depends_on = [null_resource.master_firewalls]

  triggers = {
    this = jsonencode({
      type          = var.type
      version       = var.rke_version
      channel       = var.channel
      disables      = var.disables
      registries    = var.registries
      leader        = keys(var.master_nodes)[0] == each.key
      load_balancer = coalesce(var.load_balancer, values(var.master_nodes)[0].connection.host)
      token_id      = random_string.token_id.result
      token_secret  = random_string.token_secret.result
      master_token  = random_string.master_token.result
      worker_token  = random_string.worker_token.result
      node          = each.value
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

  provisioner "file" {
    when        = create
    destination = "/tmp/script.sh"
    content     = templatefile("${path.module}/config/master.create.sh", jsondecode(self.triggers.this))
  }
  provisioner "remote-exec" {
    when = create
    inline = [<<-EOF
        echo "${jsondecode(self.triggers.this).node.connection.password}" | sudo -S -v
        sudo chmod +x /tmp/script.sh
        sudo /tmp/script.sh
    EOF
    ]
  }

  provisioner "file" {
    when        = destroy
    destination = "/tmp/script.sh"
    content     = templatefile("${path.module}/config/master.destroy.sh", jsondecode(self.triggers.this))
  }
  provisioner "remote-exec" {
    when = destroy
    inline = [<<-EOF
        echo "${jsondecode(self.triggers.this).node.connection.password}" | sudo -S -v
        sudo chmod +x /tmp/script.sh
        sudo /tmp/script.sh
    EOF
    ]
  }
}

resource "null_resource" "worker_nodes" {
  for_each   = var.worker_nodes
  depends_on = [null_resource.worker_firewalls]

  triggers = {
    this = jsonencode({
      type          = var.type
      version       = var.rke_version
      channel       = var.channel
      disables      = var.disables
      registries    = var.registries
      load_balancer = coalesce(var.load_balancer, values(var.master_nodes)[0].connection.host)
      worker_token  = random_string.worker_token.result
      node          = each.value
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

  provisioner "file" {
    when        = create
    destination = "/tmp/script.sh"
    content     = templatefile("${path.module}/config/worker.create.sh", jsondecode(self.triggers.this))
  }
  provisioner "remote-exec" {
    when = create
    inline = [<<-EOF
        echo "${jsondecode(self.triggers.this).node.connection.password}" | sudo -S -v
        sudo chmod +x /tmp/script.sh
        sudo /tmp/script.sh
    EOF
    ]
  }

  provisioner "file" {
    when        = destroy
    destination = "/tmp/script.sh"
    content     = templatefile("${path.module}/config/worker.destroy.sh", jsondecode(self.triggers.this))
  }
  provisioner "remote-exec" {
    when = destroy
    inline = [<<-EOF
        echo "${jsondecode(self.triggers.this).node.connection.password}" | sudo -S -v
        sudo chmod +x /tmp/script.sh
        sudo /tmp/script.sh
    EOF
    ]
  }
}
