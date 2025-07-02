
resource "aws_alb" "lb" {
  security_groups = [aws_security_group.ALBSG.id]
  name = "${var.project_Name}-ALB"
  internal = false
  load_balancer_type = "application"
  subnets = values(module.vpc.public_subnet_ids)
}


resource "aws_alb_listener" "alb_listener" {
    load_balancer_arn = aws_alb.lb.arn
    port = 80
    protocol = "HTTP"
    default_action {
    type  = "redirect"
    redirect {
      port = "443"
      protocol = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}



resource "aws_alb_listener" "https_alb_listener" {
    load_balancer_arn = aws_alb.lb.arn
    certificate_arn = aws_acm_certificate.cert.arn
    ssl_policy = "ELBSecurityPolicy-2016-08"
    protocol = "HTTPS"
    port = 443
    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.alb_tg.arn
    }
}

resource "aws_lb_target_group" "alb_tg" {
  name     = "${var.project_Name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 100
    matcher             = 200
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 6
    unhealthy_threshold = 3
  }
}


resource "aws_lb_target_group_attachment" "alb_attachments" {
  for_each = aws_instance.webapps
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id        = aws_instance.webapps[each.key].id
  port             = 80
}
