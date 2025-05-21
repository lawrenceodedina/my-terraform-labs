variable "projectname" {
  type = string
  default = "project"
}

variable "az1" {
    type = string
    default = "us-east-1a"
}


variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "public_sub1_cidr" {
  type = string
  default = "10.0.1.0/24"
}
