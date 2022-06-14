
module "lambda_role" {
  source        = "./modules/iam"
  iam_role_name = join("_", ["lambda_bgd_iam_role", terraform.workspace])
}


data "archive_file" "lambda_bgd_code" {
  type        = "zip"
  output_path = "lambda_bgd.zip"
  source_dir  = pathexpand("${path.module}/files/lambda")
}


data "archive_file" "healthcheck_lambda_bgd_code" {
  type        = "zip"
  output_path = "healthcheck_lambda_bgd.zip"
  source_dir  = pathexpand("${path.module}/files/lambda_healthcheck")
}



data "archive_file" "testing_lambda_bgd_code" {
  type        = "zip"
  output_path = "testing_lambda_bgd.zip"
  source_dir  = pathexpand("${path.module}/files/lambda_testing")
}

data "aws_iam_policy_document" "vpc_endpoint_policy" {
  statement {
    sid    = "sid1"
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions = [
      "*",
    ]
    resources = [join("", ["arn:aws:execute-api:", var.aws_region, ":", data.aws_caller_identity.current.account_id, ":", module.apigw.id, "/*"])]
  }
}

data "aws_caller_identity" "current" {}
