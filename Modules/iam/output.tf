output "eks_master_role_arn" {
  description = "The ARN of the IAM role for EKS"
  value       = aws_iam_role.eks_cluster_role.arn
}

output "eks_worker_role_arn" {
  description = "The ARN of the IAM role for EKS worker nodes"
  value       = aws_iam_role.eks_node_role.arn  
}

output "fargate_role_arn" {
  description = "The ARN of the IAM role for EKS worker nodes"
  value       = aws_iam_role.fargate_profile_role.arn  
}

output "policy_associations" {
  description = "List of IAM policy attachments for the EKS cluster"
  value       = [aws_iam_role_policy_attachment.eks_cluster_policy.id, 
                 aws_iam_role_policy_attachment.eks_service_policy.id, 
                 aws_iam_role_policy_attachment.eks_worker_node_policy.id, 
                 aws_iam_role_policy_attachment.eks_cni_policy.id, 
                 aws_iam_role_policy_attachment.ecr_read_only.id]
}