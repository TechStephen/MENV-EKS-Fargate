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

variable "cluster_policy_association" {
  description = "Clust policy association for EKS"
  type        = string
}

variable "service_policy_association" {
  description = "Service policy association for EKS"
  type        = string
}