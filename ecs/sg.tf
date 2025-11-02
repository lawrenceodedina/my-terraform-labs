resource "aws_security_group" "albsg" {
  vpc_id = aws_vpc.femivpc.id
  description = "Security group for ecs ALB"
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ECS SG"
  }
}


resource "aws_security_group_rule" "inboundalb" {
    type = "ingress"
    security_group_id = aws_security_group.albsg.id
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
}