terraform {
  # Assumes s3 bucket and dynamo DB table already set up
  # See 02-webapp/backend folder

  backend "s3" {
    bucket         = "terraform-dive-tf-state" # rename to your bucket
    key            = "07-managing-multiple-environments/production/terraform.tfstate"
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

variable "db_pass" {
  description = "password for database"
  type        = string
  sensitive   = true
}

locals {
  environment_name = "production"
}

module "web_app" {
  source = "../../../04-modules/web-app-module"

  # Input Variables
  bucket_prefix    = "web-app-data-${local.environment_name}"
  domain           = "mycoolsite.com"
  environment_name = local.environment_name
  instance_type    = "t2.micro"
  create_dns_zone  = false
  db_name          = "${local.environment_name}mydb"
  db_user          = "foo"
  db_pass          = var.db_pass
}
