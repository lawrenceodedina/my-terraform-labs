resource "aws_lb" "uzumakilb" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.albsg.id]
  subnets            = [aws_subnet.sub1.id, aws_subnet.sub2.id]
  

  tags = {
    Name = "Uzumaki-lb"
  }
}

resource "aws_lb_target_group" "uzumakitg" {
  name        = "uzumakiTG"
  target_type = "ip"
  port        = 80
  protocol    = "HTTP"
  
  vpc_id      = aws_vpc.femivpc.id
}


resource "aws_lb_listener" "alblistener" {
  load_balancer_arn = aws_lb.uzumakilb.arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.uzumakitg.arn
  }
}


