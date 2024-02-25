# Configuring Backend state file which is storing the in the bucket and State locking file enabling and configured AWS provider
terraform {
  backend "s3" {
    bucket         = "my-ews-baket1"
    region         = "us-east-1"
    key            = "Adventurekk/dev/terraform.state"
    dynamodb_table = "Lock-Files"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}