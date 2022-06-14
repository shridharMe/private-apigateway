output "arn" {
  value = aws_api_gateway_rest_api.example.arn
}

output "id" {
  value = aws_api_gateway_rest_api.example.id
}

output "polic_resources" {
  value = join("",["arn:aws:execute-api:",var.aws_region,":",var.aws_account,":",aws_api_gateway_rest_api.example.id,"/*"])
}