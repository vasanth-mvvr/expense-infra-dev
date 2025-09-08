variable "project_name" {
  type = string
  default = "expense"
}

variable "environment" {
  type = string
  default = "dev"
}

variable "common_tags" {
  type = map
  default = {
    Name = "expense"
    environment = "dev"
    Terraform = "true"
    Component = "web-alb"
  }

}

variable "zone_name" {
  default = "vasanthreddy.space"
}