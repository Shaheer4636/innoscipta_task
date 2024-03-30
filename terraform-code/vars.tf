# Define variables
variable "region" {
  default = "ap-northeast-1"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "subnet01_cidr_block" {
  default = "10.0.1.0/24"
}

variable "subnet02_cidr_block" {
  default = "10.0.2.0/24"
}

variable "availability_zone_a" {
  default = "ap-northeast-1a"
}

variable "availability_zone_b" {
  default = "ap-northeast-1c"
}

variable "ssh_port" {
  default = 22
}

variable "ssh_cidr_blocks" {
  default = ["0.0.0.0/0"]
}
variable "node_group_name" {
  description = "Name for the EKS node group"
  type        = string
  default     = "node-group"
}
