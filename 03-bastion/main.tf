module "bastion" {
  name = "${var.project_name}-${var.environment}-bastion"
  source = "terraform-aws-modules/ec2-instance/aws"
  instance_type = "t3.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.bastion_sg_id.value]
  ##so here again we need to convert stringlist into list to use we will split the function
  ## then after splitting we should take the first element
  subnet_id = local.public_subnet_ids
  user_data = file("bastion.sh")
  ami = data.aws_ami.ami_info.id
  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-bastion"
    }
  )

}