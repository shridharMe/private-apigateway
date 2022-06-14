module "alb" {
  source          = "terraform-aws-modules/alb/aws"
  version         = "~> 6.0"
  name            = join("-", ["alb", var.alb_name])
  vpc_id          = var.vpc_id
  security_groups = [var.security_group_id]
  subnets         = var.private_subnets
  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
      action_type        = "forward"
    }
  ]
  target_groups = [
    {
      name_prefix = "l1-"
      target_type = "lambda"
    }
  ]
}


/*
module "alb_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"
  name        = join("-",["alb","ssg",var.alb_name]) 
  description = "ALB for lambda usage"
  vpc_id      = var..vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp"]
  egress_rules = ["all-all"]
}
*/