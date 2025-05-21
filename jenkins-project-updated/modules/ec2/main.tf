data "aws_ami" "al2023" {
  most_recent = true
  owners = [ "amazon" ]

  filter {
    name = "name"
    values = [ "al2023-ami-*-x86_64" ]
  }
}

resource "aws_instance" "ec2" {
  instance_type = var.instancetype
  ami = data.aws_ami.al2023.id
  subnet_id = var.subnet_id
  vpc_security_group_ids = [ aws_security_group.jenkinssg.id ]
  key_name = aws_key_pair.ec2_key.key_name
  user_data = file("modules\\ec2\\userdata.sh") # I am using windows

  tags = {
    Name = "${var.ec2name}-instance"
  }
}