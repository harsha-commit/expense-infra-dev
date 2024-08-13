module "vpn" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "${var.project_name}-${var.environment}-vpn"

  instance_type = "t3.micro"
  key_name      = aws_key_pair.vpn.key_name
  ami           = data.aws_ami.openvpn.id

  vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]
  subnet_id              = split(",", data.aws_ssm_parameter.public_subnet_ids.value)[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_key_pair" "vpn" {
  key_name   = "vpn"
  public_key = file("openvpn.pub")
}
