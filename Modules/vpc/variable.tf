variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "subnet_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "enviroment" {
  description = "The environment for the VPC."
  type        = string
}

variable "private" {
  description = "Whether the subnet is private or public."
  type        = bool
  default     = false
}