resource "aws_security_group" "mysg" {
  name        = "${var.env}-SG"
  description = "SSH and http access"
  vpc_id      = aws_vpc.myvpc.id

  tags = {
    Name = "femi-${var.env}-SG"
  }
}

#Open all outbound ports
resource "aws_vpc_security_group_egress_rule" "outbound" {
  security_group_id = aws_security_group.mysg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
}

#Open SSH inbound
resource "aws_vpc_security_group_ingress_rule" "SSH" {
  security_group_id = aws_security_group.mysg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

#Open HTTP
resource "aws_vpc_security_group_ingress_rule" "HTTP" {
  security_group_id = aws_security_group.mysg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}