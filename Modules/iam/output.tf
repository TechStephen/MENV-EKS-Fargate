output "eks_master_role_arn" {
  description = "The ARN of the IAM role for EKS"
  value       = aws_iam_role.eks_cluster_role.arn
}

output "fargate_role_arn" {
  description = "The ARN of the IAM role for EKS worker nodes"
  value       = aws_iam_role.fargate_profile_role.arn  
}

output "clust_policy_association" {
  description = "List of IAM policy attachments for the EKS cluster"
  value       = aws_iam_role_policy_attachment.eks_cluster_policy 
}

output "service_policy_association" {
  description = "List of IAM policy attachments for the EKS service"
  value       = aws_iam_role_policy_attachment.eks_service_policy

}