output "ca_crt" {
  value     = data.k8sbootstrap_auth.this.ca_crt
  sensitive = true
  description = "RKE CA Certificate"
}

output "kubeconfig" {
  value     = data.k8sbootstrap_auth.this.kubeconfig
  sensitive = true
  description = "RKE Kubernetes Configuration"
}
