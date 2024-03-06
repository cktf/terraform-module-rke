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

output "kubeconfig" {
  value       = try(ssh_sensitive_resource.kubeconfig[0].result, null)
  sensitive   = true
  description = "Cluster Kubernetes Config"
}
