variable "type" {
  type        = string
  default     = "k3s"
  sensitive   = false
  description = "Cluster Type"

  validation {
    condition     = contains(["k3s", "rke2"], var.type)
    error_message = "Valid values for 'type' are (k3s, rke2)."
  }
}

variable "channel" {
  type        = string
  default     = "stable"
  sensitive   = false
  description = "Cluster Channel"

  validation {
    condition     = contains(["stable", "latest", "testing"], var.channel)
    error_message = "Valid values for 'channel' are (stable, latest, testing)."
  }
}

variable "version_" {
  type        = string
  default     = ""
  sensitive   = false
  description = "Cluster Version"
}

variable "registries" {
  type        = any
  default     = {}
  sensitive   = false
  description = "Cluster Registries"
}

variable "configs" {
  type        = any
  default     = {}
  sensitive   = false
  description = "Cluster Configs"
}

variable "addons" {
  type        = map(string)
  default     = {}
  sensitive   = false
  description = "Cluster AddOns"
}

variable "server_ip" {
  type        = string
  default     = ""
  sensitive   = false
  description = "Cluster Server IP"
}

variable "external_db" {
  type        = string
  default     = ""
  sensitive   = false
  description = "Cluster External DB"
}

variable "servers" {
  type = map(object({
    connection = any
    channel    = optional(string)
    version    = optional(string)
    registries = optional(any, {})
    configs    = optional(any, {})
    pre_exec   = optional(string, "")
    post_exec  = optional(string, "")
  }))
  default     = {}
  sensitive   = false
  description = "Cluster Servers"
}

variable "agents" {
  type = map(object({
    connection = any
    channel    = optional(string)
    version    = optional(string)
    registries = optional(any, {})
    configs    = optional(any, {})
    pre_exec   = optional(string, "")
    post_exec  = optional(string, "")
  }))
  default     = {}
  sensitive   = false
  description = "Cluster Agents"
}
