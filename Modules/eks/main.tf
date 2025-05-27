# Create EKS Cluster (Master Control Plane)
resource "aws_eks_cluster" "app_cluster" {
  name     = "${var.enviroment}-eks-cluster"
  role_arn = var.eks_master_role_arn
  version  = "1.21"

  vpc_config {
    subnet_ids = var.subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  depends_on = [
    var.policy_associations[0], 
    var.policy_associations[1],
  ]
}

# Create EKS Node Group (Worker Nodes)
resource "aws_eks_node_group" "app_node_group" {
  cluster_name    = aws_eks_cluster.app_cluster.name
  node_group_name = "app-node-group"
  node_role_arn   = var.eks_worker_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  depends_on = [
    var.policy_associations[2],
    var.policy_associations[3],
    var.policy_associations[4]
  ]

  lifecycle {
    create_before_destroy = true
  }
}

# Fargate Profile for EKS FE
resource "aws_eks_fargate_profile" "app_fe_fargate_profile" {
  cluster_name = aws_eks_cluster.app_cluster.name
  fargate_profile_name = "${var.enviroment}-fargate-profile-fe"
  pod_execution_role_arn = var.fargate_role_arn
  subnet_ids = var.subnet_ids

  selector {
    namespace = "${var.enviroment}-eks-fargate-fe"
  }
}

# Fargate Profile for EKS MS
resource "aws_eks_fargate_profile" "app_ms_fargate_profile" {
  cluster_name = aws_eks_cluster.app_cluster.name
  fargate_profile_name = "${var.enviroment}-fargate-profile-ms"
  pod_execution_role_arn = var.fargate_role_arn
  subnet_ids = var.subnet_ids

  selector {
    namespace = "${var.enviroment}-eks-fargate-ms"
  }
}



