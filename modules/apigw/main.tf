resource "aws_api_gateway_rest_api" "example" {
  name        = var.api_gateway_rest_api_name
  description = "Private rest api with vpce"
  endpoint_configuration {
    types            = ["PRIVATE"]
    vpc_endpoint_ids = [var.vpc_endpoint_ids]
  }
  disable_execute_api_endpoint = false
}

resource "aws_api_gateway_resource" "example" {
  for_each    = var.aipgw_objects
  parent_id   = aws_api_gateway_rest_api.example.root_resource_id
  path_part   = each.value.api_gateway_stage_path_part #"example"
  rest_api_id = aws_api_gateway_rest_api.example.id
}
resource "aws_api_gateway_method" "example" {
  for_each      = var.aipgw_objects
  authorization = each.value.api_gateway_rest_api_authorization #"NONE"
  http_method   = each.value.api_gateway_method_http_method     #"GET"
  resource_id   = aws_api_gateway_resource.example[each.key].id
  rest_api_id   = aws_api_gateway_rest_api.example.id
}


resource "aws_api_gateway_method_response" "response_200" {
  for_each    = var.aipgw_objects
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_resource.example[each.key].id
  http_method = aws_api_gateway_method.example[each.key].http_method
  status_code = "200"
}

resource "aws_api_gateway_integration" "example" {
  for_each                = var.aipgw_objects
  http_method             = aws_api_gateway_method.example[each.key].http_method
  resource_id             = aws_api_gateway_resource.example[each.key].id
  rest_api_id             = aws_api_gateway_rest_api.example.id
  integration_http_method = each.value.api_gateway_integration_http_method #"POST"
  type                    = each.value.api_gateway_integration_type        #"AWS_PROXY"
  uri                     = each.value.lambda_invoke_arn                   #aws_lambda_function.lambda.invoke_arn
}


resource "aws_api_gateway_integration_response" "example" {
  for_each    = var.aipgw_objects
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_resource.example[each.key].id
  http_method = aws_api_gateway_method.example[each.key].http_method
  status_code = aws_api_gateway_method_response.response_200[each.key].status_code


}


resource "aws_api_gateway_rest_api_policy" "example" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  policy      = data.aws_iam_policy_document.apigw_resource_policy.json
}

data "aws_iam_policy_document" "apigw_resource_policy" {
  statement {
    sid    = "sid1"
    effect = "Deny"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions = [
      "execute-api:Invoke",
    ]
    resources = [join("", ["arn:aws:execute-api:", var.aws_region, ":", var.aws_account, ":", aws_api_gateway_rest_api.example.id, "/*"])]
    condition {
      test     = "StringNotEquals"
      variable = "aws:sourceVpc"
      values   = [var.vpc_id]
    }
  }
  statement {
    sid    = "sid2"
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions = [
      "execute-api:Invoke",
    ]
    resources = [join("", ["arn:aws:execute-api:", var.aws_region, ":", var.aws_account, ":", aws_api_gateway_rest_api.example.id, "/*"])]
  }
}

resource "aws_lambda_permission" "apigw" {
  for_each      = var.aipgw_objects
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = each.value.lambda_arn
  principal     = "apigateway.amazonaws.com"

  #--------------------------------------------------------------------------------
  # Per deployment
  #--------------------------------------------------------------------------------
  # The /*/*  grants access from any method on any resource within the deployment.
  # source_arn = "${aws_api_gateway_deployment.test.execution_arn}/*/*"

  #--------------------------------------------------------------------------------
  # Per API
  #--------------------------------------------------------------------------------
  # The /*/*/* part allows invocation from any stage, method and resource path
  # within API Gateway REST API.
  source_arn = join("", [aws_api_gateway_rest_api.example.execution_arn, "/*/*/*"])


}



/*
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Deny",
            "Principal": "*",
            "Action": "execute-api:Invoke",
            "Resource": "arn:aws:execute-api:us-east-2:753690273280:5uw6vt0cvj/*",
            "Condition": {
                "StringNotEquals": {
                    "aws:sourceVpc": "vpc-0e9684717a4a1590c"
                }
            }
        },
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "execute-api:Invoke",
            "Resource": "arn:aws:execute-api:us-east-2:753690273280:5uw6vt0cvj/*"
        }
    ]
}*/

/*

resource "aws_api_gateway_deployment" "example" {
  rest_api_id = aws_api_gateway_rest_api.example.id

  triggers = {
    # NOTE: The configuration below will satisfy ordering considerations,
    #       but not pick up all future REST API changes. More advanced patterns
    #       are possible, such as using the filesha1() function against the
    #       Terraform configuration file(s) or removing the .id references to
    #       calculate a hash against whole resources. Be aware that using whole
    #       resources will show a difference after the initial implementation.
    #       It will stabilize to only change when resources change afterwards.
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.example.*.id,
      aws_api_gateway_method.example.*.id,
      aws_api_gateway_integration.example.*.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "example" {
  deployment_id = aws_api_gateway_deployment.example.id
  rest_api_id   = aws_api_gateway_rest_api.example.id
  stage_name    = var.api_gateway_stage_name #"example"
}
*/