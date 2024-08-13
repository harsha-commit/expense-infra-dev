# DB SG ID
data "aws_ssm_parameter" "db_sg_id" {
  name = "/${var.project_name}/${var.environment}/db_sg_id"
}

# Public Subnet ID
data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/public_subnet_ids"
}

# DB Subnet Group Name
data "aws_ssm_parameter" "db_subnet_group_name" {
  name = "/${var.project_name}/${var.environment}/db_subnet_group_name"
}
