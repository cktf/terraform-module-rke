variable "cluster_type" {
  type        = string
  default     = "k3s"
  sensitive   = false
  description = "Cluster Type"

  validation {
    condition     = contains(["k3s", "rke2"], var.type)
    error_message = "Valid values for `type` are (k3s, rke2)."
  }
}

variable "cluster_name" {
  type        = string
  default     = ""
  sensitive   = false
  description = "Cluster Name"
}

variable "cluster_version" {
  type        = string
  default     = ""
  sensitive   = false
  description = "Cluster Version"
}

variable "cluster_channel" {
  type        = string
  default     = ""
  sensitive   = false
  description = "Cluster Channel"
}

variable "cluster_registries" {
  type = map(object({
    endpoint = string
    username = string
    password = string
  }))
  default     = {}
  sensitive   = false
  description = "RKE Registries"
}

variable "load_balancer" {
  type        = string
  default     = ""
  sensitive   = false
  description = "RKE Load Balancer"
}

variable "cluster" {
  type = map(object({
    pre_create   = string
    post_create  = string
    pre_destroy  = string
    post_destroy = string
    name         = string
    labels       = list(string)
    taints       = list(string)
    connections  = map(any)
  }))
  default     = {}
  sensitive   = false
  description = "RKE Master Nodes"
}

variable "node_pools" {
  type = map(object({
    pre_create   = string
    post_create  = string
    pre_destroy  = string
    post_destroy = string
    name         = string
    labels       = list(string)
    taints       = list(string)
    connection   = map(any)
  }))
  default     = {}
  sensitive   = false
  description = "RKE Worker Nodes"
}
