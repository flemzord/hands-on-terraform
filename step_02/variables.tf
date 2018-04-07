variable "name" {
  type        = "string"
  description = "Unique name"
}

variable "host_cidr" {
  description = "CIDR IPv4 range to assign to EC2"
  type        = "string"
  default     = "10.0.0.0/16"
}

variable "instance_type" {
  type        = "string"
  default     = "t2.small"
  description = "EC2 instance type"
}

variable "instance_ami" {
  type        = "string"
  default     = "ami-f90a4880"
  description = "EC2 ami"
}

variable "instance_keypair" {
  type        = "string"
  description = "Public Key for SSH connexion"
}
