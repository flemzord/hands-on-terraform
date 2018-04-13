variable "name" {
  type        = "string"
  description = "Unique name"
}

variable "host_cidr" {
  description = "CIDR IPv4 range to assign to EC2"
  type        = "string"
  default     = "10.0.0.0/16"
}
