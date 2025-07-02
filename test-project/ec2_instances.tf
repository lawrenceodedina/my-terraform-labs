module "vpc" {
    source = "./modules/vpc"
}


data "aws_ami" "amzn2" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-kernel-*-x86_64-ebs"]
  }
}



resource "aws_instance" "bastion" {
  for_each = module.vpc.public_subnet_ids
  subnet_id = each.value
  ami = data.aws_ami.amzn2.id
  instance_type = var.instance_type
  key_name = aws_key_pair.utcbastion.key_name
  security_groups = [ aws_security_group.bastionSG.id ]
  tags = {
    Name = "${var.project_Name}-bastion"
  }
}

locals {
  bucket_name = aws_s3_bucket.utcbucket.bucket
}


resource "aws_instance" "webapps" {
  for_each = module.vpc.private_app_subnet_ids
  subnet_id = each.value
  ami = data.aws_ami.amzn2.id
  instance_type = var.instance_type
  user_data = templatefile("userdata.tftpl", {efsid=aws_efs_file_system.efs.id,bucket_name=aws_s3_bucket.utcbucket.bucket})
  key_name = aws_key_pair.utcwebapp.key_name
  security_groups = [ aws_security_group.WebAppSG.id ]
  iam_instance_profile = aws_iam_instance_profile.webappprofile.name
  tags = {
    Name = "${var.project_Name}-webapp"
  }
}