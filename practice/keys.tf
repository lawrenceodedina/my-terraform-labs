# Creates a key pair
resource "tls_private_key" "keypair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#Public key to be stored in instance
resource "aws_key_pair" "ec2_key" {
  key_name   = "${var.env}-keypair"
  public_key = tls_private_key.keypair.public_key_openssh
}

resource "local_file" "private_key" {
  filename = "${var.env}-key.pem"
  content = tls_private_key.keypair.private_key_pem
}