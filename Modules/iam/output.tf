output "eks_master_role_arn" {
  description = "The ARN of the IAM role for EKS"
  value       = aws_iam_role.eks_cluster_role.arn
}

output "eks_worker_role_arn" {
  description = "The ARN of the IAM role for EKS worker nodes"
  value       = aws_iam_role.eks_node_role.arn  
}