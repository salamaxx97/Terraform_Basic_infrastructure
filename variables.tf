variable "aws_region" {
  default = "us-east-1"
}

variable "aws_profile" {
  default = "default"
}

variable "vpc_cidr" {
  type = string
}

variable "subnet_cidrs" {
  type = map(list(string))
}

variable "security_groups" {
  type = map(any)
}

variable "availability_zones" {
  type = list(any)
}

variable "instances" {
  type = map(any)
}

variable "ami" {
  type = string
}
variable "instance_type" {
  type = string
}

# variable "user_data" {
#   type = map(any)
# }
