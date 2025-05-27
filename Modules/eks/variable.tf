variable "subnet_ids" {
  description = "The IDs of the subnets for EKS"
  type        = list(string)
}

variable "enviroment" {
  description = "The environment for the EKS cluster"
  type        = string
}

variable "eks_master_role_arn" {
  description = "The ARN of the EKS master role"
  type        = string
}

variable "fargate_role_arn" {
  description = "The ARN of the EKS Fargate role"
  type        = string  
}