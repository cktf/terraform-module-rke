variable "name" {
  type        = string
  default     = ""
  sensitive   = false
  description = "Cluster Name"
}

variable "type" {
  type        = string
  default     = "k3s"
  sensitive   = false
  description = "Cluster Type"

  validation {
    condition     = contains(["k3s", "rke2"], var.type)
    error_message = "Valid values for `type` are (k3s, rke2)."
  }
}

variable "channel" {
  type        = string
  default     = "latest"
  sensitive   = false
  description = "Cluster Channel"
}

variable "version_" {
  type        = string
  default     = "v1.24.3+k3s1"
  sensitive   = false
  description = "Cluster Version"
}

variable "registries" {
  type = map(object({
    endpoint = string
    username = string
    password = string
  }))
  default     = {}
  sensitive   = false
  description = "Cluster Registries"
}

variable "pods_cidr" {
  type        = string
  default     = "10.244.0.0/16"
  sensitive   = false
  description = "Cluster Pods CIDR"
}

variable "private_alb" {
  type        = string
  default     = null
  sensitive   = false
  description = "Cluster ALB Private IP"
}

variable "public_alb" {
  type        = string
  default     = null
  sensitive   = false
  description = "Cluster ALB Public IP"
}

variable "masters" {
  type        = map(any)
  default     = {}
  sensitive   = false
  description = "Cluster Masters"
}

variable "nodes" {
  type        = map(any)
  default     = {}
  sensitive   = false
  description = "Cluster Nodes"
}
