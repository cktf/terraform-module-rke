output "host" {
  value       = "https://${coalesce(var.load_balancer, values(var.master_nodes)[0].connection.host)}:6443"
  sensitive   = false
  description = "RKE Host"
}

output "token" {
  value       = "${random_string.token_id.result}.${random_string.token_secret.result}"
  sensitive   = true
  description = "RKE Token"
}

output "ca_crt" {
  value       = data.k8sbootstrap_auth.this.ca_crt
  sensitive   = true
  description = "RKE CA Certificate"
}

output "kubeconfig" {
  value       = data.k8sbootstrap_auth.this.kubeconfig
  sensitive   = true
  description = "RKE Kubernetes Config"
}
