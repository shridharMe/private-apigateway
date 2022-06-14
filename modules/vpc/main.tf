module "vpc" {
  source          = "terraform-aws-modules/vpc/aws"
  version         = "3.13.0"
  name            = var.vpc_name
  cidr            = var.vpc_cidr
  azs             = data.aws_availability_zones.available.names
  private_subnets = var.private_subnets_cidrs
  public_subnets  = var.public_subnets_cidrs

  enable_nat_gateway = true
  enable_vpn_gateway = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Terraform   = "true"
    Environment = var.project_environment
    Project     = var.project_name
  }
}


data "aws_availability_zones" "available" {
  state = "available"
  filter {
    name   = "region-name"
    values = [var.aws_region]
  }
}


