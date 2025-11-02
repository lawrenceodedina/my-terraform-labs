output "ssh_command" {
  value = "ssh -i ${local_file.private_key.filename} ec2-user@${aws_instance.ec2.public_ip}"
}

output "url_to_enter_on_browser" {
  value = "http://${aws_instance.ec2.public_ip}:80"
}