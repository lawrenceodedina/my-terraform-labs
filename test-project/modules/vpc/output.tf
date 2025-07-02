output "vpc_id" {
  value = aws_vpc.my_vpc.id
}


output "public_subnet_ids" {
    value = {for subnet, subnet_value in aws_subnet.public_subnets:subnet => subnet_value.id }
}


output "private_app_subnet_ids" {
    value = {for pva_subnet, pva_subnet_value in aws_subnet.private_app_subnets:pva_subnet => pva_subnet_value.id }
}


output "private_db_subnet_ids" {
    value = {for pvdb_subnet, pvdb_subnet_value in aws_subnet.private_db_subnets:pvdb_subnet => pvdb_subnet_value.id }
}