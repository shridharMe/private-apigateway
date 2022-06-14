resource "aws_vpc_endpoint" "apigw" {
  vpc_id              = var.vpc_id
  service_name        = var.service_name
  vpc_endpoint_type   = var.vpc_endpoint_type
  security_group_ids  = [var.security_group_ids]
  subnet_ids          = var.subnets
  private_dns_enabled = true
  tags = {
    Name = var.name
  }
}

resource "aws_vpc_endpoint_policy" "vpc_endpoint_policy" {
  vpc_endpoint_id = aws_vpc_endpoint.apigw.id
  policy          = var.policy_json
}
