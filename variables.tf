# If you want to create new VPC use vpc_cidr,private_subnets_cidrs, public_subnets_cidrs variables
variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "VPC cidrs"
}

variable "private_subnets_cidrs" {
  type        = list(any)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  description = "private subnets cidrs"
}
variable "public_subnets_cidrs" {
  type        = list(any)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  description = "public subnets cidrs"
}


# If you want to use existing VPC then provide vpc_id, private_subnets, public_subnets
variable "vpc_id" {
  default     = ""
  description = "VPC id (optional)"
}

variable "private_subnets" {
  type        = list(any)
  default     = []
  description = "Private Subnet Id's"
}

variable "public_subnets" {
  type        = list(any)
  default     = []
  description = "Public Subnet Id's"
}

variable "aws_region_map" {
  type = map(any)
  default = {
    "west"      = "w"
    "east"      = "e"
    "south"     = "s"
    "north"     = "n"
    "central"   = "c"
    "southeast" = "se"
    "northeast" = "ne"
  }
}

variable "project_name" {
  type        = string
  description = "project name"
  default     = "lambda-bgd"
}

variable "aws_region" {
  type        = string
  description = "aws region"
  default     = "us-east-2"
}

variable "project_environment" {
  type        = string
  description = "project environment"
  default     = "dev"
}


variable "infra_label" {
  type        = string
  description = "Infrastructre labelling to identify the aws resources"
  default     = ""
}


variable "lambda_handler" {
  type        = string
  default     = "index.handler"
  description = "lambda function handler"

}

variable "lambda_runtime" {
  type        = string
  default     = "python3.7"
  description = "lambda function runtime"

}