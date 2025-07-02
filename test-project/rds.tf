#RDS SUBNET GROUP
resource "aws_db_subnet_group" "subnet_group" {
  subnet_ids = values(module.vpc.private_db_subnet_ids)
  name = "utc-subnetgroup"
  tags = {
    Name = "utc-subnetgroup"
  }
}

#RDS INSTANCE
resource "aws_db_instance" "db" {
  identifier = "utcdb"
  db_name = "${var.project_Name}db"
  vpc_security_group_ids = [aws_security_group.RDS_SG.id]
  instance_class = var.rds_instance_class
  engine = "mysql"
  engine_version = "8.0.41"
  skip_final_snapshot = true
  db_subnet_group_name = aws_db_subnet_group.subnet_group.name
  username = var.rds_username
  password = var.rds_password
  allocated_storage = "20"
  tags = {
    Name = "${var.project_Name}db"
  }
  depends_on = [ aws_instance.webapps ]
}