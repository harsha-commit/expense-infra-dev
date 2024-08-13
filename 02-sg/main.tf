module "db" {
  source         = "git::https://github.com/harsha-commit/terraform-aws-sg.git"
  sg_name        = "db"
  sg_description = "Security Group for DB"
  project_name   = var.project_name
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
}

module "backend" {
  source         = "git::https://github.com/harsha-commit/terraform-aws-sg.git"
  sg_name        = "backend"
  sg_description = "Security Group for Backend"
  project_name   = var.project_name
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
}

module "frontend" {
  source         = "git::https://github.com/harsha-commit/terraform-aws-sg.git"
  sg_name        = "frontend"
  sg_description = "Security Group for Frontend"
  project_name   = var.project_name
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
}

module "bastion" {
  source         = "git::https://github.com/harsha-commit/terraform-aws-sg.git"
  sg_name        = "bastion"
  sg_description = "Security Group for Bastion"
  project_name   = var.project_name
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
}

module "vpn" {
  source              = "git::https://github.com/harsha-commit/terraform-aws-sg.git"
  sg_name             = "vpn"
  sg_description      = "Security Group for VPN"
  basic_ingress_rules = var.vpn_ingress_rules
  project_name        = var.project_name
  vpc_id              = data.aws_ssm_parameter.vpc_id.value
}

module "app_alb" {
  source         = "git::https://github.com/harsha-commit/terraform-aws-sg.git"
  sg_name        = "app-alb"
  sg_description = "Security Group for App ALB"
  project_name   = var.project_name
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
}

module "web_alb" {
  source         = "git::https://github.com/harsha-commit/terraform-aws-sg.git"
  sg_name        = "web-alb"
  sg_description = "Security Group for Web ALB"
  project_name   = var.project_name
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
}

