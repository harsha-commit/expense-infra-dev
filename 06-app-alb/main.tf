resource "aws_lb" "backend" {
  name               = "${var.project_name}-${var.environment}-app-alb"
  internal           = true
  load_balancer_type = "application"

  security_groups = [data.aws_ssm_parameter.app_alb_sg_id.value]
  subnets         = split(",", data.aws_ssm_parameter.public_subnet_ids.value)

  tags = {
    Environment = "production"
  }
}

# Listener
resource "aws_lb_listener" "backend" {
  load_balancer_arn = aws_lb.backend.arn
  port              = "80"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Hello harsha, Great Work, keep it on 🔥🔥🔥🔥</h1>"
      status_code  = "200"
    }
  }
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = var.zone_name

  records = [
    {
      name            = "*.app-${var.environment}"
      type            = "A"
      allow_overwrite = true
      alias = {
        name    = aws_lb.backend.dns_name
        zone_id = aws_lb.backend.zone_id
      }
    }
  ]
}
