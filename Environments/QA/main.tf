provider "aws" {
    region = "us-east-1"
}

terraform {
    #backend "s3" {
    #    bucket         = "my-terraform-state-bucket"
    #    key            = "qa/terraform.tfstate"
    #    region         = "us-east-1"
    #    dynamodb_table = "terraform-locks"
    #}

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
    vpc_cidr_block = "192.0.0.0/16"
    subnet_cidr_block = "192.0.0.0/24"
    enviroment = "QA"
}

module "eks" {
    source = "../../Modules/eks"
    enviroment = "QA"
    subnet_ids = module.vpc.subnet_ids
    policy_associations = module.iam.policy_associations
    eks_worker_role_arn = module.iam.eks_worker_role_arn
    eks_master_role_arn = module.iam.eks_master_role_arn
    fargate_role_arn = module.iam.fargate_role_arn
}