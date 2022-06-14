
module "vpc" {
  source                = "./modules/vpc"
  vpc_name              = join("_", ["lambda_bgd_vpc", terraform.workspace])
  vpc_cidr              = var.vpc_cidr
  private_subnets_cidrs = var.private_subnets_cidrs
  public_subnets_cidrs  = var.public_subnets_cidrs
  aws_region            = var.aws_region

}



module "sg" {
  source             = "./modules/sg"
  vpc_id             = module.vpc.vpc_id
  vpc_cidr_block     = var.vpc_cidr
  sg_for_lambda_name = join("_", ["allow_tls", terraform.workspace])

}


module "lambda" {
  source                  = "./modules/lambda"
  lambda_function_name    = join("_", ["lambda_bgd", terraform.workspace])
  vpc_id                  = module.vpc.vpc_id
  private_subnets_ids     = module.vpc.private_subnets
  vpc_cidr_block          = var.vpc_cidr
  lambda_filename         = data.archive_file.lambda_bgd_code.output_path
  lambda_source_code_hash = data.archive_file.lambda_bgd_code.output_base64sha256
  lambda_role_arn         = module.lambda_role.iam_role_arn
  security_group_ids      = [module.sg.ids]
  lambda_handler          = "index.handler"
  lambda_runtime          = "python3.7"

}





module "lambda_healthcheck" {
  source                  = "./modules/lambda"
  lambda_function_name    = join("_", ["lambda_bgd_healthcheck", terraform.workspace])
  vpc_id                  = module.vpc.vpc_id
  private_subnets_ids     = module.vpc.private_subnets
  vpc_cidr_block          = var.vpc_cidr
  lambda_filename         = data.archive_file.healthcheck_lambda_bgd_code.output_path
  lambda_source_code_hash = data.archive_file.healthcheck_lambda_bgd_code.output_base64sha256
  lambda_role_arn         = module.lambda_role.iam_role_arn
  security_group_ids      = [module.sg.ids]
  lambda_handler          = "index.handler"
  lambda_runtime          = "python3.7"
}

module "lambda_testing" {
  source                  = "./modules/lambda"
  lambda_function_name    = join("_", ["lambda_bgd_testing", terraform.workspace])
  vpc_id                  = module.vpc.vpc_id
  private_subnets_ids     = module.vpc.private_subnets
  vpc_cidr_block          = var.vpc_cidr
  lambda_filename         = data.archive_file.testing_lambda_bgd_code.output_path
  lambda_source_code_hash = data.archive_file.testing_lambda_bgd_code.output_base64sha256
  lambda_role_arn         = module.lambda_role.iam_role_arn
  security_group_ids      = [module.sg.ids]
  lambda_handler          = "index.handler"
  lambda_runtime          = "python3.7"
  env_variables = {
    APIGATEWAY_URL = join("", ["https://", module.apigw.id, ".execute-api.", var.aws_region, ".amazonaws.com/dev/hello"])
  }
}

module "vpce_apigw" {
  source             = "./modules/vpce"
  name               = "lambda_bgd_vpce"
  vpc_id             = module.vpc.vpc_id
  service_name       = join("", ["com.amazonaws.", var.aws_region, ".execute-api"])
  vpc_endpoint_type  = "Interface"
  security_group_ids = module.sg.ids
  subnets            = module.vpc.private_subnets
  policy_json        = data.aws_iam_policy_document.vpc_endpoint_policy.json
}







module "apigw" {
  source                    = "./modules/apigw"
  api_gateway_rest_api_name = "lambda_bgd_api"
  aws_region                = var.aws_region
  aws_account               = data.aws_caller_identity.current.account_id
  api_gateway_stage_name    = "dev"
  vpc_id                    = module.vpc.vpc_id
  vpc_endpoint_ids          = module.vpce_apigw.id
  aipgw_objects = {
    api_1 = {
      api_gateway_stage_path_part         = "hello",
      api_gateway_method_http_method      = "GET",
      api_gateway_rest_api_authorization  = "NONE",
      api_gateway_integration_http_method = "POST",
      api_gateway_integration_type        = "AWS"
      lambda_invoke_arn                   = module.lambda.invoke_arn
      lambda_arn                          = module.lambda.arn
    },
    api_2 = {
      api_gateway_stage_path_part         = "healthcheck",
      api_gateway_method_http_method      = "GET",
      api_gateway_rest_api_authorization  = "NONE",
      api_gateway_integration_http_method = "POST"
      api_gateway_integration_type        = "AWS"
      lambda_invoke_arn                   = module.lambda_healthcheck.invoke_arn
      lambda_arn                          = module.lambda_healthcheck.arn
    }
  }
}