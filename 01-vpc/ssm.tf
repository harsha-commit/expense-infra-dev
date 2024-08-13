resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.project_name}/${var.environment}/vpc_id"
  type  = "String"
  value = module.vpc-test.vpc_id
}

resource "aws_ssm_parameter" "public_subnet_ids" {
  name  = "/${var.project_name}/${var.environment}/public_subnet_ids"
  type  = "StringList"
  value = join(",", module.vpc-test.public_subnet_ids)
}

resource "aws_ssm_parameter" "private_subnet_ids" {
  name  = "/${var.project_name}/${var.environment}/private_subnet_ids"
  type  = "StringList"
  value = join(",", module.vpc-test.private_subnet_ids)
}

resource "aws_ssm_parameter" "database_subnet_ids" {
  name  = "/${var.project_name}/${var.environment}/database_subnet_ids"
  type  = "StringList"
  value = join(",", module.vpc-test.database_subnet_ids)
}

resource "aws_ssm_parameter" "db_subnet_group_name" {
  name  = "/${var.project_name}/${var.environment}/db_subnet_group_name"
  type  = "String"
  value = module.vpc-test.db_subnet_group_name
}
