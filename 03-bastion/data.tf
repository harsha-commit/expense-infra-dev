# Bastion SG ID
data "aws_ssm_parameter" "bastion_sg_id" {
  name = "/${var.project_name}/${var.environment}/bastion_sg_id"
}

# Public Subnet ID
data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/public_subnet_ids"
}
