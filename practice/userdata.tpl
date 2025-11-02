#!/bin/bash
yum update -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd
echo "<h1>Hello from the ${env} environment in terraform playboi</h1>" >> /var/www/html/index.html