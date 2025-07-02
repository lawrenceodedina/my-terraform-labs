provider "aws" {
  region = "us-east-1"
}


resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true
  tags = {
    Name = "${var.project_name}-VPC"
  }
}


resource "aws_internet_gateway" "my_igw" {
    vpc_id = aws_vpc.my_vpc.id
    tags = {
      Name = "${var.project_name}-IGW"
    }
}

resource "aws_subnet" "public_subnets" {
    for_each = var.public_subnet_map
    availability_zone = each.value.az
    cidr_block = each.value.cidr_block
    vpc_id = aws_vpc.my_vpc.id
    map_public_ip_on_launch = true
    tags = {
      Name = each.key
    }
}


resource "aws_subnet" "private_app_subnets" {
    for_each = var.private_app_subnet_map
    availability_zone = each.value.az
    cidr_block = each.value.cidr_block
    vpc_id = aws_vpc.my_vpc.id
    tags = {
      Name = each.key
    }
}


resource "aws_subnet" "private_db_subnets" {
    for_each = var.private_db_subnet_map
    availability_zone = each.value.az
    cidr_block = each.value.cidr_block
    vpc_id = aws_vpc.my_vpc.id
    tags = {
      Name = each.key
    }
}


#Nat gateway and eip
resource "aws_eip" "my_eip1" {
  tags = {
    Name = "${var.project_name}-EIP1"
  }
}


resource "aws_eip" "my_eip2" {
  tags = {
    Name = "${var.project_name}-EIP2"
  }

}


resource "aws_nat_gateway" "my_nat_gw1" {
    subnet_id = aws_subnet.public_subnets[keys(aws_subnet.public_subnets)[0]].id
    allocation_id = aws_eip.my_eip1.id
    tags = {
      Name = "${var.project_name}-GW1"
    }
}


resource "aws_nat_gateway" "my_nat_gw2" {
    subnet_id = aws_subnet.public_subnets[keys(aws_subnet.public_subnets)[1]].id
    allocation_id = aws_eip.my_eip2.id
    tags = {
      Name = "${var.project_name}-GW2"
    }
}


# Public RT
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
  tags = {
    Name = "${var.project_name}-public-RT"
  }
}


# Public RT association
resource "aws_route_table_association" "public_RT_association" {
  for_each = aws_subnet.public_subnets
  subnet_id = aws_subnet.public_subnets[each.key].id
  route_table_id = aws_route_table.public_rt.id
}


# Private RT and RTA for private app subnets
resource "aws_route_table" "private_rt1" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my_nat_gw1.id
  }
  tags = {
    Name = "${var.project_name}-private-RT1"
  }
}


resource "aws_route_table_association" "private_RTA1" {
  subnet_id = aws_subnet.private_app_subnets[keys(aws_subnet.private_app_subnets)[0]].id
  route_table_id = aws_route_table.private_rt1.id
}


resource "aws_route_table" "private_rt2" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my_nat_gw2.id
  }
  tags = {
    Name = "${var.project_name}-private-RT2"
  }
}


resource "aws_route_table_association" "private_RTA2" {
  subnet_id = aws_subnet.private_app_subnets[keys(aws_subnet.private_app_subnets)[1]].id
  route_table_id = aws_route_table.private_rt2.id
}


resource "aws_route_table" "private_rt_db" {
  for_each = aws_subnet.private_db_subnets
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = var.vpc_cidr_block
    gateway_id = "local"
  }
  tags = {
    Name = "${var.project_name}-${each.key}-RT"
  }
}


resource "aws_route_table_association" "private_rta_db" {
  for_each = aws_route_table.private_rt_db
  route_table_id = aws_route_table.private_rt_db[each.key].id
  subnet_id = aws_subnet.private_db_subnets[each.key].id
}
