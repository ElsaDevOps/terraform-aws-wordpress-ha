output "wp_efs_id" {
  description = "The ID of the EFS"
  value       = aws_efs_file_system.wp_efs.id
}
