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

variable "disables" {
  type        = list(string)
  default     = []
  sensitive   = false
  description = "RKE Disables"
}

variable "registries" {
  type = map(object({
    endpoint = string
    username = optional(string)
    password = optional(string)
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

variable "https_proxy" {
  type        = string
  default     = ""
  sensitive   = false
  description = "RKE HTTPS Proxy"
}

variable "http_proxy" {
  type        = string
  default     = ""
  sensitive   = false
  description = "RKE HTTP Proxy"
}

variable "no_proxy" {
  type        = string
  default     = ""
  sensitive   = false
  description = "RKE No Proxy"
}

variable "master_nodes" {
  type = map(object({
    pre_create   = optional(string)
    post_create  = optional(string)
    pre_destroy  = optional(string)
    post_destroy = optional(string)
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
    pre_create   = optional(string)
    post_create  = optional(string)
    pre_destroy  = optional(string)
    post_destroy = optional(string)
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
    pre_create   = optional(string)
    post_create  = optional(string)
    pre_destroy  = optional(string)
    post_destroy = optional(string)
    name         = string
    labels       = list(string)
    taints       = list(string)
    connection   = map(any)
  }))
  default     = {}
  sensitive   = false
  description = "RKE Windows Worker Nodes"
}
