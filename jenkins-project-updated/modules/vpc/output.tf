output "vpc_name" {
  value = "${var.projectname}-vpc"
}

output "public-subnet-id" {
  value = aws_subnet.public-subnet1.id
}

output "vpc_id" {
  value = aws_vpc.my_vpc.id
}
