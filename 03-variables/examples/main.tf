terraform {
  backend "s3" {
    bucket         = "terrraform-dive-tf-state" # rename to your bucket
    key            = "04-variables-and-outputs/examples/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# scoped to this project
# not passed in
locals {
  extra_tag = "extra-tag"
}

# "var." variables defined in variables.tf

# ec2
resource "aws_instance" "instance" {
  ami           = var.ami
  instance_type = var.instance_type

  tags = {
    Name     = var.instance_name
    ExtraTag = local.extra_tag
  }
}

#db
resource "aws_db_instance" "db_instance" {
  allocated_storage   = 20
  storage_type        = "gp2"
  engine              = "postgres"
  engine_version      = "12"
  instance_class      = "db.t2.micro"
  name                = "mydb"
  username            = var.db_user
  password            = var.db_pass
  skip_final_snapshot = true
}
