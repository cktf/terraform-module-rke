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

variable "disable" {
  type        = string
  default     = ""
  sensitive   = false
  description = "RKE Disable"
}

variable "loadbalancer" {
  type        = string
  default     = ""
  sensitive   = false
  description = "RKE Servers Load Balancer Host"
}

variable "masters" {
  type = map(object({
    name       = string
    labels     = map(string)
    taints     = map(string)
    connection = map(any)
  }))
  default     = {}
  sensitive   = false
  description = "RKE Masters"
}

variable "workers" {
  type = map(object({
    name       = string
    labels     = map(string)
    taints     = map(string)
    connection = map(any)
  }))
  default     = {}
  sensitive   = false
  description = "RKE Workers"
}

variable "windows_workers" {
  type = map(object({
    name       = string
    labels     = map(string)
    taints     = map(string)
    connection = map(any)
  }))
  default     = {}
  sensitive   = false
  description = "RKE Windows Workers"
}
