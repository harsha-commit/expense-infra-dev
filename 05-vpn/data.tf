# VPN Security Group ID
data "aws_ssm_parameter" "vpn_sg_id" {
  name = "/${var.project_name}/${var.environment}/vpn_sg_id"
}

# Public Subnet
data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/public_subnet_ids"
}

# OpenVPN AMI ID
data "aws_ami" "openvpn" {
  most_recent = true
  owners      = ["679593333241"]

  filter {
    name   = "name"
    values = ["OpenVPN Access Server Community Image-fe8020db-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
