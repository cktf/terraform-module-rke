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

variable "name" {
  type        = string
  default     = ""
  sensitive   = false
  description = "RKE Name"
}

# variable "version" {
#   type        = string
#   default     = ""
#   sensitive   = false
#   description = "RKE Version"
# }

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
