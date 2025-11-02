resource "aws_vpc" "myvpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.env}-VPC"
  }
}


resource "aws_subnet" "mysubnet" {
  vpc_id = aws_vpc.myvpc.id
  availability_zone = var.subnet_az
  cidr_block = var.subnet_cidr
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.env}-public-subnet"
  }
}


resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "${var.env}-igw"
  }
}


resource "aws_route_table" "myrt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myigw.id
  }
  tags = {
    Name = "${var.env}-RT"
  }
}


resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.mysubnet.id
  route_table_id = aws_route_table.myrt.id
}