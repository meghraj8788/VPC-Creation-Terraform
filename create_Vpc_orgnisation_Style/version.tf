terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      version = "~> 4.0"
      source = "hashicorp/aws"
    }
  }
  backend "storage" {
  bucket = "my-tfstate-bucket-meghraj"
  key    = "devops/terraform.tfstate"
  encryption = true
  use_lockfile = true
  region = "us-east-1"
}
}

module "s3" {
  source = "./module/s3"
}

provider "aws" {
  region = var.region
}



