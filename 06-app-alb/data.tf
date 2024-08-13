# VPN Security Group ID
data "aws_ssm_parameter" "app_alb_sg_id" {
  name = "/${var.project_name}/${var.environment}/app_alb_sg_id"
}

# Public Subnet
data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/public_subnet_ids"
}
