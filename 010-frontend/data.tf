# Frontend Security Group ID
data "aws_ssm_parameter" "frontend_sg_id" {
  name = "/${var.project_name}/${var.environment}/frontend_sg_id"
}

# Public Subnet IDs
data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/public_subnet_ids"
}

# VPC ID
data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project_name}/${var.environment}/vpc_id"
}

data "aws_ssm_parameter" "web_alb_listener_arn" {
  name = "/${var.project_name}/${var.environment}/web_alb_listener_arn"
}
