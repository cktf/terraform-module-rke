output "host" {
  depends_on = [data.k8sbootstrap_auth.this]

  value       = "https://${local.public_alb}:6443"
  sensitive   = false
  description = "Cluster Host"
}

output "token" {
  depends_on = [data.k8sbootstrap_auth.this]

  value       = "${random_string.token_id.result}.${random_string.token_secret.result}"
  sensitive   = true
  description = "Cluster Token"
}

output "ca_crt" {
  value       = data.k8sbootstrap_auth.this.ca_crt
  sensitive   = true
  description = "Cluster CA Certificate"
}

output "kubeconfig" {
  value       = data.k8sbootstrap_auth.this.kubeconfig
  sensitive   = true
  description = "Cluster Kubernetes Config"
}
