module "frontend" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "${var.project_name}-${var.environment}-frontend"
  ami  = "ami-041e2ea9402c46c32"

  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.frontend_sg_id.value]
  subnet_id              = split(",", data.aws_ssm_parameter.public_subnet_ids.value)[0]

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-frontend",
  })
}

resource "null_resource" "frontend" {
  triggers = {
    instance_id = module.frontend.id
  }

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = module.frontend.private_ip
  }

  provisioner "file" {
    source      = "frontend.sh"
    destination = "/tmp/frontend.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/frontend.sh",
      "sudo sh /tmp/frontend.sh frontend ${var.environment}"
    ]
  }
}

resource "aws_ec2_instance_state" "frontend" {
  instance_id = module.frontend.id
  state       = "stopped"
  depends_on  = [null_resource.frontend]
}

resource "aws_ami_from_instance" "frontend" {
  name               = "${var.project_name}-${var.environment}-frontend-ami"
  source_instance_id = module.frontend.id
  depends_on         = [aws_ec2_instance_state.frontend]
}

resource "null_resource" "frontend_delete" {
  triggers = {
    instance_id = module.frontend.id
  }

  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${module.frontend.id}"
  }

  depends_on = [aws_ami_from_instance.frontend]
}

resource "aws_lb_target_group" "frontend" {
  name     = "${var.project_name}-${var.environment}-frontend-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_ssm_parameter.vpc_id.value

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 15
    matcher             = "200-299"
    path                = "/health"
    port                = 80
    protocol            = "HTTP"
    timeout             = 10
  }
}

resource "aws_launch_template" "frontend" {
  name     = "${var.project_name}-${var.environment}-frontend-template"
  image_id = aws_ami_from_instance.frontend.id

  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = "t3.micro"
  update_default_version               = true

  vpc_security_group_ids = [data.aws_ssm_parameter.frontend_sg_id.value]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.project_name}-${var.environment}-frontend-template"
    }
  }
}

resource "aws_autoscaling_group" "frontend" {
  name                      = "${var.project_name}-${var.environment}-frontend-asg"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 60
  health_check_type         = "ELB"
  desired_capacity          = 1

  vpc_zone_identifier = split(",", data.aws_ssm_parameter.public_subnet_ids.value)
  target_group_arns   = [aws_lb_target_group.frontend.arn]

  instance_maintenance_policy {
    min_healthy_percentage = 90
    max_healthy_percentage = 120
  }

  launch_template {
    id      = aws_launch_template.frontend.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 80
    }
    triggers = ["launch_template"]
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-${var.environment}-frontend-asg"
    propagate_at_launch = true
  }

  timeouts {
    delete = "10m"
  }
}

resource "aws_autoscaling_policy" "frontend" {
  name                   = "${var.project_name}-${var.environment}-frontend"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.frontend.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 40.0
  }
}

resource "aws_lb_listener_rule" "static" {
  listener_arn = data.aws_ssm_parameter.web_alb_listener_arn.value
  priority     = 100 // less number, more priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }

  condition {
    host_header {
      // for host path
      values = ["web-${var.environment}.${var.zone_name}"]
    }
  }
}
