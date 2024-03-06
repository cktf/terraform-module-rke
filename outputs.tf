output "host" {
  value       = var.server_ip
  sensitive   = false
  description = "Cluster Host"
}

output "port" {
  value       = local.port
  sensitive   = false
  description = "Cluster Port"
}

output "config" {
  value       = try(ssh_sensitive_resource.kubeconfig[0].result, null)
  sensitive   = true
  description = "Cluster Config"
}

output "client_key" {
  value       = try(base64decode(yamldecode(ssh_sensitive_resource.kubeconfig[0].result).users[0].user.client-key-data), null)
  sensitive   = true
  description = "Cluster Client Key"
}

output "client_crt" {
  value       = try(base64decode(yamldecode(ssh_sensitive_resource.kubeconfig[0].result).users[0].user.client-certificate-data), null)
  sensitive   = true
  description = "Cluster Client Certificate"
}

output "ca_crt" {
  value       = try(base64decode(yamldecode(ssh_sensitive_resource.kubeconfig[0].result).clusters[0].cluster.certificate-authority-data), null)
  sensitive   = true
  description = "Cluster CA Certificate"
}
