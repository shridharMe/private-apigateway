variable "vpc_id" {
  type = string
}

variable "service_name" {
  type = string
}
variable "vpc_endpoint_type" {
  type    = string
  default = "Interface"
}

variable "security_group_ids" {
  type = string
}
variable "subnets" {
  type = list(any)
}

variable "policy_json" {
  type = string
}

variable "name" {
  type = string
}