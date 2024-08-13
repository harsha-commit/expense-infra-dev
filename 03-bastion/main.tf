module "bastion" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name          = "${var.project_name}-${var.environment}-bastion"
  instance_type = "t3.micro"
  ami           = "ami-041e2ea9402c46c32"

  user_data              = file("bastion.sh")
  vpc_security_group_ids = [data.aws_ssm_parameter.bastion_sg_id.value]
  subnet_id              = split(",", data.aws_ssm_parameter.public_subnet_ids.value)[0]

  tags = var.bastion_tags
}
