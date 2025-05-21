
output "instancetype" {
  value = aws_instance.ec2.instance_type
}

output "security_group_ids" {
  value = aws_instance.ec2.vpc_security_group_ids
}

output "ami_id" {
  value = aws_instance.ec2.ami
}

output "keyname" {
  value = aws_instance.ec2.key_name
}

output "ssh_command" {
  value = "ssh -i ${local_file.ssh_key.filename} ec2-user@${aws_instance.ec2.public_ip}"
}

output "Jenkins_url" {
  value = "${aws_instance.ec2.public_ip}:8080"
}
