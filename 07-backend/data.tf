# Backend Security Group ID
data "aws_ssm_parameter" "backend_sg_id" {
  name = "/${var.project_name}/${var.environment}/backend_sg_id"
}

# Private Subnet IDs
data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/private_subnet_ids"
}

# VPC ID
data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project_name}/${var.environment}/vpc_id"
}

data "aws_ssm_parameter" "app_alb_listener_arn" {
  name = "/${var.project_name}/${var.environment}/app_alb_listener_arn"
}
