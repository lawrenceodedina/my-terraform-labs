data "aws_ami" "al2023" {
  most_recent = true
  filter {
    name = "name"
    values = [ "al2023-ami-*-kernel-6.1-x86_64" ]
  }
}

resource "aws_instance" "ec2" {
  instance_type = var.ec2_type
  ami = data.aws_ami.al2023.id
  subnet_id = aws_subnet.mysubnet.id
  security_groups = [aws_security_group.mysg.id]
  key_name = aws_key_pair.ec2_key.key_name
  user_data = templatefile("userdata.tpl", {env="${var.env}"})

  tags = {
    Name = "${var.env}-instance"
    environmnet = var.env
  }
}