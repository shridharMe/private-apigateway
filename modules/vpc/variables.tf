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


variable "aws_region" {
  type        = string
  description = "aws region"
  default     = ""
}

/*variable "azs" {
  type        = list(any)
  description = "availability zones"
}*/

variable "vpc_name" {
  type        = string
  default     = ""
  description = "VPC Name"
}

variable "project_environment" {
  type        = string
  description = "project environment"
  default     = "dev"
}


variable "project_name" {
  type        = string
  description = "project name"
  default     = "lambda-bgd"
}