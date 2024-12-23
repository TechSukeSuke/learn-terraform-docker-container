terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

locals {
  app_name = "how-aws-rds-run"
  region   = "ap-northeast-1"
  host_domain = "ikobel.com"
  app_domain_name = "www.ikobel.com"
  api_domain_name = "api.ikobel.com"
  ssm_parameter_store_base = "/ikobel/prd"
}

provider "aws" {
  region = local.region
  default_tags {
    tags = {
      application = local.app_name
    }
  }
}
