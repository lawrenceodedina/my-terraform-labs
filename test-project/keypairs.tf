#Generates Key Pair for bastion
resource "tls_private_key" "bastion_key_pair" {
  algorithm = "RSA"
  rsa_bits = "4096"
}

#Public Key
resource "aws_key_pair" "utcbastion" {
    key_name = "${var.project_Name}bastion"
    public_key = tls_private_key.bastion_key_pair.public_key_openssh
}

#Saves private key in file locally
resource "local_file" "utcbastion_key" {
  content = tls_private_key.bastion_key_pair.private_key_pem
  filename = "${var.project_Name}bastion.pem"
}



#Generates Key Pair for webapp
resource "tls_private_key" "webapp_key_pair" {
  algorithm = "RSA"
  rsa_bits = "4096"
}

#Public Key
resource "aws_key_pair" "utcwebapp" {
    key_name = "${var.project_Name}webapp"
    public_key = tls_private_key.webapp_key_pair.public_key_openssh
}

#Saves private key in file locally
resource "local_file" "utcwebapp_key" {
  content = tls_private_key.webapp_key_pair.private_key_pem
  filename = "${var.project_Name}webapp.pem"
}