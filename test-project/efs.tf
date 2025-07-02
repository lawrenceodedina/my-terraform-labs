resource "aws_efs_file_system" "efs" {
  creation_token = "utc-token"
  throughput_mode = "elastic"
  encrypted = true

  tags = {
    Name = "${var.project_Name}-efs"
  }
}

resource "aws_efs_mount_target" "efs_mount_targets" {
  for_each = module.vpc.private_app_subnet_ids
  file_system_id = aws_efs_file_system.efs.id
  security_groups = [ aws_security_group.EFSSG.id ]
  subnet_id = each.value
}