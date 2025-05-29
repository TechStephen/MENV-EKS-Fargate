# Create EKS Cluster (Master Control Plane)
resource "aws_eks_cluster" "app_cluster" {
  name     = "${var.enviroment}-eks-cluster"
  role_arn = var.eks_master_role_arn
  version  = "1.32" # Keep newest version compatible with app

  vpc_config {
    subnet_ids = [var.subnet_ids[0], var.subnet_ids[1]] 
    endpoint_private_access = true
    endpoint_public_access  = true
  }
}

# Worker Node Group for AWS-LBC (EC2 Based - Required for ALB Ingress Controller)
resource "aws_eks_node_group" "app_worker_nodes" {
  cluster_name    = aws_eks_cluster.app_cluster.name
  node_group_name = "${var.enviroment}-alb-worker-nodes"
  node_role_arn   = var.alb_worker_role_arn
  subnet_ids      = [var.subnet_ids[2], var.subnet_ids[3]] # Use NAT Gateway Public subnets since ALB needs internet access

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t2.small"] 
  ami_type        = "AL2_x86_64" # Use Amazon Linux 2 AMI for compatibility with ALB Ingress Controller
  capacity_type   = "ON_DEMAND" # Use On-Demand instances for ALB worker nodes
  tags = {
    Name        = "${var.enviroment}-alb-node-group"
    Environment = var.enviroment
  }

  depends_on = [aws_eks_cluster.app_cluster]
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



