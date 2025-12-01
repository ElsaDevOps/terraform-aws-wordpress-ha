terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
resource "aws_efs_file_system" "wp_efs" {
  creation_token = "wordpress-efs-token"

  tags = {
    Name = "wordpress-efs"
  }
}





resource "aws_efs_mount_target" "alpha" {
  for_each        = module.vpc.private_subnet_id_data
  file_system_id  = aws_efs_file_system.wp_efs.id
  subnet_id       = each.value
  security_groups = [aws_security_group.efs_sg.id]
}
