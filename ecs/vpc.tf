resource "aws_vpc" "femivpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${var.name}-vpc"
  }
}


resource "aws_subnet" "sub1" {
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  vpc_id = aws_vpc.femivpc.id
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.name}-subnet-1"
  }
}


resource "aws_subnet" "sub2" {
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  vpc_id = aws_vpc.femivpc.id
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.name}-subnet-1"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.femivpc.id
  tags = {
    Name = "${var.name}-igw"
  }
}


resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.femivpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.name}-rt"
  }
}


resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.rt.id
}


resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.sub2.id
  route_table_id = aws_route_table.rt.id
}