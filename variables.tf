variable "aws_region"{
    default = "us-east-1"
}

variable "aws_profile"{
    default = "default"
}

variable "vpc_cidr"{
    type = string 
}

variable "public_subnet_cidr" {
    type = string 
}
variable "private_subnet_cidr" {
    type = string 
}
variable "private_availability_zone" {
    type = string 
}
variable "public_availability_zone" {
    type = string 
}
variable "ami" {
    type = string 
}
variable "instance_type" {
    type = string 
}

variable "user_data" {
    type = string 
}
