variable "name" {
  type        = "string"
  description = "Unique name"
  default     = "devoxx"
}

variable "host_cidr" {
  description = "CIDR IPv4 range to assign to EC2"
  type        = "string"
  default     = "10.0.0.0/16"
}

variable "instance_type" {
  type        = "string"
  default     = "t2.micro"
  description = "EC2 instance type"
}

variable "instance_ami" {
  type        = "string"
  default     = "ami-bfff49c2"
  description = "EC2 ami"
}

variable "public_key_path" {
  type        = "string"
  description = "Public Key for SSH connexion"
  default     = "../devoxx.key.pub"
}
