variable "vpc_cidr_block" {
    type = string
    default = "10.10.0.0/16"
}


variable "project_name" {
    type = string
    default = "utcapp" 
}


variable "public_subnet_map" {
    type = map(object({
    cidr_block = string
    az = string
  }))
  default = {
    "public_subnet_1" = {
      az  = "us-east-1a"
      cidr_block = "10.10.1.0/24"
    },
    "public_subnet_2" = {
      az = "us-east-1b"
      cidr_block = "10.10.2.0/24"
    }
  }
}


variable "private_app_subnet_map"{
    type = map(object({
    cidr_block = string
    az = string
  }))
  default = {
    "private_app_subnet_1" = {
      az  = "us-east-1a"
      cidr_block = "10.10.3.0/24"
    },
    "private_app_subnet_2" = {
      az = "us-east-1b"
      cidr_block = "10.10.4.0/24"
    }
  }
}


variable "private_db_subnet_map"{
    type = map(object({
    cidr_block = string
    az = string
  }))
  default = {
    "private_db_subnet_1" = {
      az  = "us-east-1a"
      cidr_block = "10.10.5.0/24"
    },
    "private_db_subnet_2" = {
      az = "us-east-1b"
      cidr_block = "10.10.6.0/24"
    }
  }
}
    
