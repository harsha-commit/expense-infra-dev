### DB SG Rules ###
resource "aws_security_group_rule" "db_backend" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = module.db.sg_id
  source_security_group_id = module.backend.sg_id
}

resource "aws_security_group_rule" "db_bastion" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = module.db.sg_id
  source_security_group_id = module.bastion.sg_id
}

resource "aws_security_group_rule" "db_vpn" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = module.db.sg_id
  source_security_group_id = module.vpn.sg_id
}

### Backend SG Rules ###
resource "aws_security_group_rule" "backend_vpn_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.backend.sg_id
  source_security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "backend_vpn_http" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.backend.sg_id
  source_security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "backend_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.backend.sg_id
  source_security_group_id = module.bastion.sg_id
}

resource "aws_security_group_rule" "backend_app_alb" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.backend.sg_id
  source_security_group_id = module.app_alb.sg_id
}

### Frontend SG Rules ###
resource "aws_security_group_rule" "frontend_public" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = module.frontend.sg_id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "frontend_web_alb" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = module.frontend.sg_id
  source_security_group_id = module.web_alb.sg_id
}

resource "aws_security_group_rule" "frontend_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.frontend.sg_id
  source_security_group_id = module.bastion.sg_id
}

resource "aws_security_group_rule" "frontend_vpn" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.frontend.sg_id
  source_security_group_id = module.vpn.sg_id
}

### Bastion SG Rules ###
resource "aws_security_group_rule" "bastion_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = module.bastion.sg_id
  cidr_blocks       = ["0.0.0.0/0"]
}

### APP ALB SG Rules ###
resource "aws_security_group_rule" "app_alb_frontend" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = module.app_alb.sg_id
  source_security_group_id = module.frontend.sg_id
}

resource "aws_security_group_rule" "app_alb_vpn" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = module.app_alb.sg_id
  source_security_group_id = module.vpn.sg_id
}

### Web ALB SG Rules ###
resource "aws_security_group_rule" "web_alb_public_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = module.web_alb.sg_id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "web_alb_public_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = module.web_alb.sg_id
  cidr_blocks       = ["0.0.0.0/0"]
}
