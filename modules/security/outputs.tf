output "rds_sg_id" {
  value = aws_security_group.rds.id
}

output "wp_alb_sg_id" {
  value = aws_security_group.wp_alb_sg.id
}

output "efs_sg_id" {
  value = aws_security_group.efs_sg.id
}

output "wp_app_sg_id" {
  value = aws_security_group.wp_app_sg.id

}
