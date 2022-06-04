variable "name" {
  type        = string
  default     = ""
  sensitive   = false
  description = "Node Pool Name"
}

variable "type" {
  type        = string
  default     = "k3s"
  sensitive   = false
  description = "Node Pool Type"

  validation {
    condition     = contains(["k3s", "rke2"], var.type)
    error_message = "Valid values for `type` are (k3s, rke2)."
  }
}

variable "version_" {
  type        = string
  default     = ""
  sensitive   = false
  description = "Node Pool Version"
}

variable "channel" {
  type        = string
  default     = ""
  sensitive   = false
  description = "Node Pool Channel"
}

variable "taints" {
  type        = map(string)
  default     = {}
  sensitive   = false
  description = "Node Pool Taints"
}

variable "labels" {
  type        = map(string)
  default     = {}
  sensitive   = false
  description = "Node Pool Labels"
}

variable "tags" {
  type        = map(string)
  default     = {}
  sensitive   = false
  description = "Node Pool Tags"
}

variable "registries" {
  type = map(object({
    endpoint = string
    username = string
    password = string
  }))
  default     = {}
  sensitive   = false
  description = "Node Pool Registries"
}

variable "connections" {
  type        = list(any)
  default     = []
  sensitive   = false
  description = "Node Pool Connections"
}

variable "cluster_url" {
  type        = string
  default     = ""
  sensitive   = false
  description = "Node Pool Cluster URL"
}

variable "cluster_token" {
  type        = string
  default     = ""
  sensitive   = true
  description = "Node Pool Cluster Token"
}

variable "extra_args" {
  type        = list(string)
  default     = []
  sensitive   = false
  description = "Node Pool Extra Arguments"
}

variable "extra_envs" {
  type        = map(string)
  default     = {}
  sensitive   = false
  description = "Node Pool Extra Environments"
}

variable "pre_create_user_data" {
  type        = string
  default     = ""
  sensitive   = false
  description = "Node Pool Pre-Create user-data"
}

variable "post_create_user_data" {
  type        = string
  default     = ""
  sensitive   = false
  description = "Node Pool Post-Create user-data"
}

variable "pre_destroy_user_data" {
  type        = string
  default     = ""
  sensitive   = false
  description = "Node Pool Pre-Destroy user-data"
}

variable "post_destroy_user_data" {
  type        = string
  default     = ""
  sensitive   = false
  description = "Node Pool Post-Destroy user-data"
}
