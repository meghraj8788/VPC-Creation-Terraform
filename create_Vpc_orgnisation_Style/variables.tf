variable "region" {
  description = "This is a region for cloud"
  type = string
  default = "us-east-1"
}

variable "cidr_block" {
  description = "This is a CIDR block for VPC"
  type = string
  default = "10.0.0.0/16"

  }

variable "bits" {
  description = "This is a CIDR block for VPC"
  type = number
  default = 8

}

variable "environment" {
  description = "This is a CIDR block for VPC"
  type = string
  default = "dev"

  }

variable "tags" {
  description = "This is a CIDR block for VPC"
  type = map(string)
  default = {
    "terraform" = "true"
  }
  }
