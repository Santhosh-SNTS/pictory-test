# provider "aws" {
#   profile                 = "axor"
#   region                  = var.aws_region
# }
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
    profile = "axor"
    region  = var.aws_region
}