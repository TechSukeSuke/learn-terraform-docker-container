terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

locals {
  app_name = "how-aws-ecs-run"
  region   = "ap-northeast-1"
}

provider "aws" {
  region = local.region
  default_tags {
    tags = {
      application = local.app_name
    }
  }
}
