provider "aws" {
    region = "us-east-1"
}

terraform {
    # backend "s3" {
    #    bucket         = "prod-eks-app-state-bucket"
    #    key            = "prod/terraform.tfstate"
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

module "iam" {
    source = "../../Modules/iam"
}

module "vpc" {
    source = "../../Modules/vpc"
    vpc_cidr_block = "192.0.20.0/16"
    subnet_cidr_blocks = ["192.0.20.0/24", "192.0.20.10/24"]
    enviroment = "Prod"
}

module "eks" {
    source = "../../Modules/eks"
    enviroment = "Prod"
    subnet_ids = module.vpc.subnet_ids
    eks_master_role_arn = module.iam.eks_master_role_arn
    fargate_role_arn = module.iam.fargate_role_arn

    depends_on = [ module.iam ]
}