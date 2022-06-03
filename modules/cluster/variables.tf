variable "name" {
  type        = string
  default     = ""
  sensitive   = false
  description = "Node Group Name"
}

variable "type" {
  type        = string
  default     = "k3s"
  sensitive   = false
  description = "Node Group Type"

  validation {
    condition     = contains(["k3s", "rke2"], var.type)
    error_message = "Valid values for `type` are (k3s, rke2)."
  }
}

variable "version_" {
  type        = string
  default     = ""
  sensitive   = false
  description = "Node Group Version"
}

variable "channel" {
  type        = string
  default     = ""
  sensitive   = false
  description = "Node Group Channel"
}

variable "taints" {
  type        = map(string)
  default     = {}
  sensitive   = false
  description = "Node Group Taints"
}

variable "labels" {
  type        = map(string)
  default     = {}
  sensitive   = false
  description = "Node Group Labels"
}

variable "tags" {
  type        = map(string)
  default     = {}
  sensitive   = false
  description = "Node Group Tags"
}

variable "registries" {
  type = map(object({
    endpoint = string
    username = string
    password = string
  }))
  default     = {}
  sensitive   = false
  description = "Node Group Registries"
}

variable "connections" {
  type        = list(any)
  default     = []
  sensitive   = true
  description = "Node Group Connections"
}

variable "extra_args" {
  type        = list(string)
  default     = []
  sensitive   = false
  description = "Node Group Extra Arguments"
}

variable "extra_envs" {
  type        = map(string)
  default     = {}
  sensitive   = false
  description = "Node Group Extra Environments"
}

variable "pre_create_user_data" {
  type        = string
  default     = ""
  sensitive   = false
  description = "Node Group Pre-Create user-data"
}

variable "post_create_user_data" {
  type        = string
  default     = ""
  sensitive   = false
  description = "Node Group Post-Create user-data"
}

variable "pre_destroy_user_data" {
  type        = string
  default     = ""
  sensitive   = false
  description = "Node Group Pre-Destroy user-data"
}

variable "post_destroy_user_data" {
  type        = string
  default     = ""
  sensitive   = false
  description = "Node Group Post-Destroy user-data"
}
