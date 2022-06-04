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

variable "version_" {
  type        = string
  default     = ""
  sensitive   = false
  description = "Cluster Version"
}

variable "channel" {
  type        = string
  default     = ""
  sensitive   = false
  description = "Cluster Channel"
}

variable "taints" {
  type        = map(string)
  default     = {}
  sensitive   = false
  description = "Cluster Taints"
}

variable "labels" {
  type        = map(string)
  default     = {}
  sensitive   = false
  description = "Cluster Labels"
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

variable "connections" {
  type        = list(any)
  default     = []
  sensitive   = false
  description = "Cluster Connections"
}

variable "extra_args" {
  type        = list(string)
  default     = []
  sensitive   = false
  description = "Cluster Extra Arguments"
}

variable "extra_envs" {
  type        = map(string)
  default     = {}
  sensitive   = false
  description = "Cluster Extra Environments"
}

variable "pre_create_user_data" {
  type        = string
  default     = ""
  sensitive   = false
  description = "Cluster Pre-Create user-data"
}

variable "post_create_user_data" {
  type        = string
  default     = ""
  sensitive   = false
  description = "Cluster Post-Create user-data"
}

variable "pre_destroy_user_data" {
  type        = string
  default     = ""
  sensitive   = false
  description = "Cluster Pre-Destroy user-data"
}

variable "post_destroy_user_data" {
  type        = string
  default     = ""
  sensitive   = false
  description = "Cluster Post-Destroy user-data"
}

variable "node_pools" {
  type        = map(any)
  default     = {}
  sensitive   = false
  description = "Cluster Node Pools"
}
