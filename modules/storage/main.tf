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
  encrypted      = true

  tags = {
    Name        = "${var.project_name}-efs"
    Project     = var.project_name
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}





resource "aws_efs_mount_target" "alpha" {
  for_each        = var.subnet_ids
  file_system_id  = aws_efs_file_system.wp_efs.id
  subnet_id       = each.value
  security_groups = [var.efs_sg_id]
}
