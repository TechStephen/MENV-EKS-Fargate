variable "subnet_ids" {
  description = "The IDs of the subnets for EKS"
  type        = list(string)
}

variable "enviroment" {
  description = "The environment for the EKS cluster"
  type        = string
}

variable "eks_worker_role_arn" {
  description = "The name of the EKS cluster"
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

variable "policy_associations" {
  description = "List of IAM policy attachments for the EKS cluster"
  type        = list(string)
}