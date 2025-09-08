variable "project_name" {
  default = "expense"
}

variable "common_tags" {
  default = {
    project_name = "expense"
    environment = "dev"
    Terraform = "true"
  }
}
variable "environment" {
  default = "dev"
}

variable "sg_description" {
  default = "DB security group description"
}

variable "sg_name" {
  default = ""
}

variable "vpn_sg_rules" {
  default = [
    {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    },
    {
    from_port = 943
    to_port = 943
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
    },
    {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
    },
    {
    from_port = 1194
    to_port = 1194
    protocol = "udp"
    cidr_blocks = ["0.0.0.0/0"] 
    }
  ]
}