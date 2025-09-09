resource "aws_key_pair" "keys" {
    key_name = "vpn"
    # public key can be given directly or in a file
#  public_key = ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDCtDhe/nhNbllKB3r629gQuUXIuSCP1MaUMh8zJGF+3mfxvij98F7VV0CYbVW3Qih9ri5LIS05j9Jg6VgzeYhuHx7PTymh8kWquAid6IKyfLrSDfH6EylT9o4YQ4EhmH1/ghYDWB+pSvAlBOetRfcSfiEoGtZdfZkSJ4jytpNgVx1XU0zH6I0YQ7e93beMy2NBmuUj6fexH3XS87yj7Y9DEWWqGLwGYGvERPLeABS35RxSNnMMlWR04NR0Tv8y/mbZTO3lYCiUt0yTUrrXFnAI21YovJZp8TElWGqq1q7svMw4ygz+Srz20jd7mxNzeCCm0BA1T/qaccxGtEtrXVZnaDnGl63lcZjdyklg7c2VCfLLoFm1QgR9fVX1GKxpw/seSGnUBZsKHmDFklaC1hEGMChLU1RBrJe3gX+gfHMgBXODUEbEszNtO8PgRsrv4Fy7lrHQVQZSgNjaQT4eqOjB29PBdLRFo6n1Qk64Z3urzensnPWquitdAepzSXhbU3c= Pravallika@DESKTOP-6PDVF9K
  public_key =  file("~/.ssh/gitkey.pub")   # ~ windows home
}

module "vpn" {
  source = "terraform-aws-modules/ec2-instance/aws"
  key_name = aws_key_pair.keys.key_name
  name = "${var.project_name}-${var.environment}-vpn"
  instance_type = "t2.micro"
  ami = data.aws_ami.ami_info.id
  vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]
  subnet_id = local.public_subnet_id
  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-vpn"
    }
  )
}