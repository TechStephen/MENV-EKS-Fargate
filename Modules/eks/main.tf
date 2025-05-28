# Create EKS Cluster (Master Control Plane)
resource "aws_eks_cluster" "app_cluster" {
  name     = "${var.enviroment}-eks-cluster"
  role_arn = var.eks_master_role_arn
  version  = "1.29" # Keep newest version compatible with app

  vpc_config {
    subnet_ids = var.subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = true
  }
}

# Fargate Profile for EKS FE
resource "aws_eks_fargate_profile" "app_fe_fargate_profile" {
  cluster_name = aws_eks_cluster.app_cluster.name
  fargate_profile_name = "${var.enviroment}-fargate-profile-fe"
  pod_execution_role_arn = var.fargate_role_arn
  subnet_ids = [var.subnet_ids[0], var.subnet_ids[1]] # Use first two subnets for FE

  selector {
    namespace = "${var.enviroment}-eks-fargate-fe"
  }

  depends_on = [  ]
}

# Fargate Profile for EKS MS
resource "aws_eks_fargate_profile" "app_ms_fargate_profile" {
  cluster_name = aws_eks_cluster.app_cluster.name
  fargate_profile_name = "${var.enviroment}-fargate-profile-ms"
  pod_execution_role_arn = var.fargate_role_arn
  subnet_ids = [var.subnet_ids[0], var.subnet_ids[1]]

  selector {
    namespace = "${var.enviroment}-eks-fargate-ms"
  }
}



