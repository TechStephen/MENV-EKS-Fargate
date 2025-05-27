output "eks_master_role_arn" {
  description = "The ARN of the IAM role for EKS"
  value       = aws_iam_role.eks_cluster_role.arn
}

output "fargate_role_arn" {
  description = "The ARN of the IAM role for EKS worker nodes"
  value       = aws_iam_role.fargate_profile_role.arn  
}

output "policy_associations" {
  description = "List of IAM policy attachments for the EKS cluster"
  value       = [aws_iam_role_policy_attachment.eks_cluster_policy.id, 
                 aws_iam_role_policy_attachment.eks_service_policy.id,]
}