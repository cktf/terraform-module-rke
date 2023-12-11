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
  default     = "stable"
  sensitive   = false
  description = "Cluster Channel"

  validation {
    condition     = contains(["stable", "latest", "testing"], var.channel)
    error_message = "Valid values for `channel` are (stable, latest, testing)."
  }
}

variable "version_" {
  type        = string
  default     = ""
  sensitive   = false
  description = "Cluster Version"
}

variable "addons" {
  type        = map(string)
  default     = {}
  sensitive   = false
  description = "Cluster AddOns"
}

variable "configs" {
  type        = any
  default     = {}
  sensitive   = false
  description = "Cluster Configs"
}

variable "registries" {
  type        = any
  default     = {}
  sensitive   = false
  description = "Cluster Registries"
}

variable "server_ip" {
  type        = string
  default     = null
  sensitive   = false
  description = "Cluster Server IP"
}

variable "masters" {
  type        = map(any)
  default     = {}
  sensitive   = false
  description = "Cluster Masters"
}

variable "workers" {
  type        = map(any)
  default     = {}
  sensitive   = false
  description = "Cluster Workers"
}
