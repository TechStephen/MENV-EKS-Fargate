output "eks_master_role_arn" {
  description = "The ARN of the IAM role for EKS"
  value       = aws_iam_role.eks_cluster_role.arn
}

output "fargate_role_arn" {
  description = "The ARN of the IAM role for EKS worker nodes"
  value       = aws_iam_role.fargate_profile_role.arn  
}