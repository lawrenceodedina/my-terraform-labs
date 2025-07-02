output "url" {
  value = aws_route53_record.A_record.name
}


output "ssh_command" {
  value = <<EOF
"ssh -i ${local_file.utcwebapp_key.filename} -o ProxyCommand="ssh -i ${local_file.utcbastion_key.filename} -W %h:%p ec2-user@${aws_instance.bastion[keys(aws_instance.bastion)[0]].public_ip}" ec2-user@${aws_instance.webapps[keys(aws_instance.webapps)[0]].private_ip}"
  EOF
}


output "mysql_connection_command" {
  value = "mysql -h ${aws_db_instance.db.endpoint} -P 3306 -u ${var.rds_username} -p"
}
