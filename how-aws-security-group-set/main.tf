terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

locals {
  app_name = "how-aws-security-group-set"
  region   = "ap-northeast-1"
  host_domain = "ikobel.com"
  app_domain_name = "www.ikobel.com"
  api_domain_name = "api.ikobel.com"
}

provider "aws" {
  region = local.region
  default_tags {
    tags = {
      application = local.app_name
    }
  }
}
