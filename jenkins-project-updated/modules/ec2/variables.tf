variable "instancetype" {
  type = string
  default = "t2.medium"
}

variable "subnet_id" {
  
}


variable "vpc_id" {
  
}

variable "projectname" {
  type = string
  default = ""
}

variable "sgname" {
  type = string
  default = "jenkins-SG"
}

variable "filename" {
  type = string
  default = "filename"
}

variable "keyname" {
  type = string
  default = "jenkins"
}

variable "ec2name" {
  type = string
  default = "Jenkins"
}