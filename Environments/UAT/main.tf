provider "aws" {
    region = "us-east-1"
}

terraform {
    # backend "UAT" {
    #    bucket         = "uat-eks-app-state-bucket"
    #    key            = "uat/terraform.tfstate"
    #    region         = "us-east-1"
    #    use_lockfile = true
    #    encrypt = true
    # }

    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 4.0"
        }
    }
    
    required_version = ">= 1.0.0"
}

module "vpc" {
    source = "../../Modules/vpc"
    vpc_cidr_block = "192.0.10.0/16"
    subnet_cidr_blocks = ["192.0.10.0/24", "192.0.10.10/24"]
    enviroment = "uat"
}

module "eks" {
    source = "../../Modules/eks"
    enviroment = "uat"
    subnet_ids = module.vpc.subnet_ids
    eks_master_role_arn = module.iam.eks_master_role_arn
    fargate_role_arn = module.iam.fargate_role_arn

    depends_on = [ module.iam ]
}