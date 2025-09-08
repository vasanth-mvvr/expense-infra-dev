data "aws_ssm_parameter" "web_alb_sg_id" {
  name = "/${var.project_name}/${var.environment}/web_alb_sg_id"
}

data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/private_subnet_ids"
}

data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/public_subnet_ids"
}

data "aws_ssm_parameter" "aws_acm_certificate_arn" {
  name = "/${var.project_name}/${var.environment}/aws_acm_certificate_arn"
}
