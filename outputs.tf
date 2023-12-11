output "host" {
  value       = "https://${var.server_ip}:6443"
  sensitive   = true
  description = "Cluster CA Certificate"
}

output "client_key" {
  value       = yamldecode(ssh_sensitive_resource.kubeconfig.result).clusters[0].cluster.certificate-authority-data
  sensitive   = true
  description = "Cluster Client Key"
}

output "client_cert" {
  value       = yamldecode(ssh_sensitive_resource.kubeconfig.result).users[0].user.client-certificate-data
  sensitive   = false
  description = "Cluster Client Certificate"
}

output "ca_cert" {
  value       = yamldecode(ssh_sensitive_resource.kubeconfig.result).users[0].user.client-key-data
  sensitive   = true
  description = "Cluster CA Certificate"
}

output "kubeconfig" {
  value       = ssh_sensitive_resource.kubeconfig.result
  sensitive   = true
  description = "Cluster Kubernetes Config"
}
