variable "project_name" {
  default = "expense"
}
variable "environment" {
  default = "dev"
}

variable "common_tags" {
  default = {
    Name = "expense"
    environment = "dev"
    Terraform = "true"
    component = "frontend"
  }

}

variable "zone_name" {
  default = "vasanthreddy.space"
}
