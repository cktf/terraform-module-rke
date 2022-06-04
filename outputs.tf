output "host" {
  value       = module.cluster.host
  sensitive   = false
  description = "Cluster Host"
}

output "token" {
  value       = module.cluster.token
  sensitive   = true
  description = "Cluster Token"
}

output "ca_crt" {
  value       = module.cluster.ca_crt
  sensitive   = true
  description = "Cluster CA Certificate"
}

output "kubeconfig" {
  value       = module.cluster.kubeconfig
  sensitive   = true
  description = "Cluster Kubernetes Config"
}
