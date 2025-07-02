variable "project_Name" {
  type = string
  default = "UTC"
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "region" {
  type = string
  default = "us-east-1"
}

variable "rds_instance_class" {
  type = string
  default = "db.t3.micro" 
}

variable "rds_username" {
  type = string
}

variable "rds_password" {
  type = string
  sensitive = true
}

variable "bucket_name" {
  type = string
  default = "utc-femiodedina-bucket"
}

variable "ami_name" {
  type = string
  default = "utcwebappami"
}

variable "email" {
  type = string
  default = "lawrenceodedina+receiver@gmail.com"
}

variable "hostedzone_id" {
  type = string
}


variable "destroy" {
  type = bool
  default = true
}