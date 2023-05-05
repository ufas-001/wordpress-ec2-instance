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

resource "aws_instance" "wordpress" {
  ami                    = module.ami.ami_id
  instance_type          = "t2.micro"
  key_name               = "terraformkey"
  vpc_security_group_ids = [module.aws_security_group.security_groups_id]
  tags = {
    "Name" = "apache-server"
  }
   user_data = file("./userdata.sh")
}
