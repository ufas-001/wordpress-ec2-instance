terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


data "aws_vpc" "main" {
  default = true
}

data "aws_subnets" "example" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
}

module "ami" {
  source = "./module/ami"
}

module "aws_security_group" {
  source = "./module/aws_security_group"
  vpc_id = data.aws_vpc.main.id
}

module "aws_instance" {
  source = "./module/aws_instance"
  aws-ami-id = module.ami.ami_id
  aws-security-group-id = module.aws_security_group.security_groups_id
  file-path = "./userdata.sh"
}