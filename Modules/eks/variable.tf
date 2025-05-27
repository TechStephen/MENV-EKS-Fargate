variable "subnet_ids" {
  description = "The IDs of the subnets for EKS"
  type        = list(string)
}

variable "enviroment" {
  description = "The environment for the EKS cluster"
  type        = string
}