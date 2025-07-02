###Security Group for bastionHost###
resource "aws_security_group" "bastionSG" {
  name = "BastionHostSG"
  description = "security Group for bastion Host"
  vpc_id = module.vpc.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}


#BastionHostSG inbound rule for ssh
resource "aws_security_group_rule" "ingress_bastion_ssh" {
  type = "ingress"
  protocol = "tcp"
  from_port = 22
  to_port = 22
  security_group_id = aws_security_group.bastionSG.id
  cidr_blocks = [ "0.0.0.0/0" ]
  description = "Accept from everywhere"
  depends_on = [ aws_security_group.bastionSG ]
}



###webAppSG###
resource "aws_security_group" "WebAppSG" {
  name = "WebAppSG"
  description = "security Group for ALB"
  vpc_id = module.vpc.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}


#WebAppSG inbound rule for ssh
resource "aws_security_group_rule" "ingress_webapp_ssh" {
  type = "ingress"
  protocol = "tcp"
  from_port = 22
  to_port = 22
  security_group_id = aws_security_group.WebAppSG.id
  source_security_group_id = aws_security_group.bastionSG.id
  description = "Accept ssh only from BastionHostSG"
  depends_on = [ aws_security_group.bastionSG ]
}


#WebAppSG inbound rule for http
resource "aws_security_group_rule" "ingress_webapp_http" {
  type = "ingress"
  protocol = "tcp"
  from_port = 80
  to_port = 80
  security_group_id = aws_security_group.WebAppSG.id
  source_security_group_id = aws_security_group.ALBSG.id
  description = "Accept http only from ALBSG"
}


#WebAppSG inbound rule for https
resource "aws_security_group_rule" "ingress_webapp_https" {
  type = "ingress"
  protocol = "tcp"
  from_port = 443
  to_port = 443
  security_group_id = aws_security_group.WebAppSG.id
  source_security_group_id = aws_security_group.ALBSG.id
  description = "Accept https only from ALBSG"
}


###ALB security Group###
resource "aws_security_group" "ALBSG" {
  name = "ALBSG"
  description = "security Group for ALB"
  vpc_id = module.vpc.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}


#ALBSG inbound rule for http
resource "aws_security_group_rule" "ingress_ALB_http" {
  type = "ingress"
  protocol = "tcp"
  from_port = 80
  to_port = 80
  security_group_id = aws_security_group.ALBSG.id
  cidr_blocks = [ "0.0.0.0/0" ]
  description = "Accept from everywhere"
  depends_on = [ aws_security_group.ALBSG ]
}


#ALBSG inbound rule for https
resource "aws_security_group_rule" "ingress_ALB_https" {
  type = "ingress"
  protocol = "tcp"
  from_port = 443
  to_port = 443
  security_group_id = aws_security_group.ALBSG.id
  cidr_blocks = [ "0.0.0.0/0" ]
  description = "Accept from everywhere"
  depends_on = [ aws_security_group.ALBSG ]
}

###RDS_SG###
resource "aws_security_group" "RDS_SG" {
  name = "RDS_SG"
  description = "RDS security Group"
  vpc_id = module.vpc.vpc_id

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


#RDS_SG inbound rule for mysql 
resource "aws_security_group_rule" "ingress_RDS_mysql" {
  type = "ingress"
  protocol = "tcp"
  from_port = 3306
  to_port = 3306
  security_group_id = aws_security_group.RDS_SG.id
  source_security_group_id = aws_security_group.WebAppSG.id
  description = "Accept inbound traffic only from WebAPPSG"
  depends_on = [ aws_security_group.RDS_SG ]
}


###EFS SG###
resource "aws_security_group" "EFSSG" {
  name = "EFSSG"
  description = "Security Group for EFS"
  vpc_id = module.vpc.vpc_id
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group_rule" "ingress_EFS" {
  type = "ingress"
  protocol = "tcp"
  from_port = 2049
  to_port = 2049
  security_group_id = aws_security_group.EFSSG.id
  source_security_group_id = aws_security_group.WebAppSG.id
  description = "Accept inbound traffic only from WebAPPSG"
  depends_on = [ aws_security_group.EFSSG ]
}