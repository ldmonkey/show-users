variable "infrastructure_version" {
  default = "1"
}
variable "region" {
  default = "eu-central-1"
}
variable "vpc_cidr" {
  description = "The CIDR Block for VPC"
  default     = "10.0.0.0/16"
}

variable "rt_wide_route" {
  description = "Route in Route Table"
  default     = "0.0.0.0/0"
}
variable "subnet_count" {
  description = "no of subnets"
  default     = 2
}
variable "availability_zones" {
  description = "availability zone to create subnet"
  default = [
    "eu-central-1a",
  "eu-central-1b"]
}
variable "flask_app_port" {
  description = "Port exposed by the flask application"
  default     = 5000
}
variable "flask_app_image" {
  description = "ECR image for flask-app"
  default     = "502647135132.dkr.ecr.eu-central-1.amazonaws.com/all-users-flask-webapp:latest"
}
