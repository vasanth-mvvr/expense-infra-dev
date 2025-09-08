module "db" {
 source = "../../aws_security_group" 
 project_name = var.project_name
 sg_description =  "db sg_group"
 environment = var.environment
 common_tags = var.common_tags
 vpc_id = data.aws_ssm_parameter.vpc_id.value
 sg_name = "db"
}
module "backend" {
 source = "../../aws_security_group" 
 project_name = var.project_name
 sg_description = "backend sg_group"
 environment = var.environment
 common_tags = var.common_tags
 vpc_id =data.aws_ssm_parameter.vpc_id.value
 sg_name = "backend"
}
module "frontend" {
 source = "../../aws_security_group" 
 project_name = var.project_name
 sg_description = "frontend sg_group"
 environment = var.environment
 common_tags = var.common_tags
 vpc_id = data.aws_ssm_parameter.vpc_id.value
 sg_name = "frontend"
}
module "bastion" {
 source = "../../aws_security_group" 
 project_name = var.project_name
 sg_description = "bastion sg_group"
 environment = var.environment
 common_tags = var.common_tags
 vpc_id = data.aws_ssm_parameter.vpc_id.value
 sg_name = "bastion"
}

module "app_alb" {
  source = "../../aws_security_group"
  project_name = var.project_name
  sg_description = "app_alb sg_group"
  environment = var.environment
  common_tags = var.common_tags
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "app_alb"
}
module "web_alb" {
  source = "../../aws_security_group"
  project_name = var.project_name
  sg_description = "web_alb sg_group"
  environment = var.environment
  common_tags = var.common_tags
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "web_alb"
}
module "vpn" {
  source = "../../aws_security_group"
  project_name = var.project_name
  sg_description = "vpn sg_group"
  environment = var.environment
  common_tags = var.common_tags
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "vpn"
  in_bound = var.vpn_sg_rules
}

resource "aws_security_group_rule" "db_backend" {
  type = "ingress"
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
  source_security_group_id = module.backend.sg_id
  security_group_id = module.db.sg_id
}
resource "aws_security_group_rule" "db_bastion" {
  type = "ingress"
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.db.sg_id
}

resource "aws_security_group_rule" "db_vpn" {
  type = "ingress"
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.db.sg_id
}

resource "aws_security_group_rule" "backend_app_alb" {
  type = "ingress"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  source_security_group_id = module.app_alb.sg_id
  security_group_id = module.backend.sg_id
}

resource "aws_security_group_rule" "backend_vpn_ssh" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.backend.sg_id
}

resource "aws_security_group_rule" "backend_vpn_http" {
  type = "ingress"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.backend.sg_id
}

resource "aws_security_group_rule" "backend_bastion" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.backend.sg_id
}
resource "aws_security_group_rule" "frontend_public" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = module.frontend.sg_id
  }
  resource "aws_security_group_rule" "app_alb_vpn" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    source_security_group_id = module.vpn.sg_id
    security_group_id = module.app_alb.sg_id
  }
  resource "aws_security_group_rule" "app_alb_bastion" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    source_security_group_id = module.bastion.sg_id
    security_group_id = module.app_alb.sg_id
  }
  resource "aws_security_group_rule" "app_alb_frontend" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    source_security_group_id = module.frontend.sg_id
    security_group_id = module.app_alb.sg_id
  }
resource "aws_security_group_rule" "frontend_web_alb" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  source_security_group_id = module.web_alb.sg_id
  security_group_id = module.frontend.sg_id
}
  resource "aws_security_group_rule" "frontend_bastion" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.frontend.sg_id
  }

  resource "aws_security_group_rule" "frontend_vpn" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    source_security_group_id = module.vpn.sg_id
    security_group_id = module.frontend.sg_id
  }
  resource "aws_security_group_rule" "bastion_public" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = module.bastion.sg_id
  }
    resource "aws_security_group_rule" "web_alb_public" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = module.web_alb.sg_id
  }
    resource "aws_security_group_rule" "web_alb_public_https" {
    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = module.web_alb.sg_id
  }
  
