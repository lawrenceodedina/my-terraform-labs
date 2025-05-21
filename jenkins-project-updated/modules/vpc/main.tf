resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.projectname}-vpc"
  }
}

resource "aws_subnet" "public-subnet1" {
  cidr_block = var.public_sub1_cidr
  vpc_id = aws_vpc.my_vpc.id
  availability_zone = var.az1
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.projectname}-public-subnet1"
  }
}


resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "${var.projectname}-igw"
  }
}

resource "aws_route_table" "myrt" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    gateway_id = aws_internet_gateway.myigw.id
    cidr_block = "0.0.0.0/0"
  }
}

resource "aws_route_table_association" "ass1" {
  subnet_id      = aws_subnet.public-subnet1.id
  route_table_id = aws_route_table.myrt.id
}
