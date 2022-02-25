variable "type" {
  type        = string
  default     = "k3s"
  sensitive   = false
  description = "RKE Type"

  validation {
    condition     = contains(["k3s", "rke2"], var.type)
    error_message = "Valid values for `type` are (k3s, rke2)."
  }
}

variable "rke_version" {
  type        = string
  default     = ""
  sensitive   = false
  description = "RKE Version"
}

variable "channel" {
  type        = string
  default     = ""
  sensitive   = false
  description = "RKE Channel"
}

variable "registry" {
  type        = string
  default     = "https://registry.hub.docker.com"
  sensitive   = false
  description = "RKE Registry"
}

variable "disables" {
  type        = list(string)
  default     = []
  sensitive   = false
  description = "RKE Disables"
}

variable "load_balancer" {
  type        = string
  default     = ""
  sensitive   = false
  description = "RKE Load Balancer"
}

variable "master_nodes" {
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
  description = "RKE Master Nodes"
}

variable "worker_nodes" {
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

variable "windows_worker_nodes" {
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
  description = "RKE Windows Worker Nodes"
}
