variable "api_gateway_rest_api_name" {
  type = string
}

variable "api_gateway_stage_name" {
  type = string
}

variable "vpc_endpoint_ids" {
  type = string
}
variable "aipgw_objects" {
  type = map(object({
    api_gateway_stage_path_part         = string
    api_gateway_method_http_method      = string
    api_gateway_rest_api_authorization  = string
    api_gateway_integration_http_method = string
    api_gateway_integration_type        = string
    lambda_invoke_arn                          = string
    lambda_arn =string
  }))
  default = {
    api_1={
      api_gateway_stage_path_part         = "hello",
      api_gateway_method_http_method      = "GET",
      api_gateway_rest_api_authorization  = "NONE",
      api_gateway_integration_http_method = "POST",
      api_gateway_integration_type        = "AWS_PROXY"
      lambda_invoke_arn                          = ""
      lambda_arn                          = ""
    },
   api_2={
      api_gateway_stage_path_part         = "healthcheck",
      api_gateway_method_http_method      = "GET",
      api_gateway_rest_api_authorization  = "NONE",
      api_gateway_integration_http_method = "POST"
      api_gateway_integration_type        = "AWS_PROXY"
      lambda_invoke_arn                          = ""
      lambda_arn =""
    }
  }
}

 variable "vpc_id" {
   type=string
 }

 variable "aws_region" {
    type=string
 }

 variable "aws_account" {
   type=string
 }