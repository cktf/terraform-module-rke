variable "name" {
  type        = string
  default     = ""
  sensitive   = false
  description = "RKE Name"
}

variable "description" {
  type        = string
  default     = ""
  sensitive   = false
  description = "RKE Description"
}

variable "external" {
  type        = string
  default     = ""
  sensitive   = false
  description = "RKE External"
}

variable "subnets" {
  type        = list(string)
  default     = []
  sensitive   = false
  description = "RKE Subnets"
}
