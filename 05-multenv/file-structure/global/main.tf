terraform {
  # Assumes s3 bucket and dynamo DB table already set up
  # See 02-webapp/backend folder
  backend "s3" {
    bucket         = "terraform-dive-tf-state" # replace with your bucket name
    key            = "07-managing-multiple-environments/global/terraform.tfstate"
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

# Route53 zone is shared across staging and production
resource "aws_route53_zone" "primary" {
  name = "mycoolwebsite.com"
}
