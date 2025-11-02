variable "aws_region" {
  type = string
  default = "us-east-1"
}

variable "vpc_cidr" {
  type = string
}

variable "subnet_cidr"{
    type = string
}

variable "env" {
  type = string
}

variable "subnet_az" {
  type = string
  default = "us-east-1a"
}

variable "ec2_type" {
  type = string
}