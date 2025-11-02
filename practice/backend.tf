terraform {
  backend "s3" {
    bucket = "s3.terraform.lawrence"
    key = "state/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraformdb"
    encrypt = true
  }
}