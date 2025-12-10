output "rds_endpoint" {
  description = "The connection endpoint for the RDS instance"
  value       = aws_db_instance.dev_db.endpoint
}

output "database_name" {
  description = "The name of the database"
  value       = aws_db_instance.dev_db.db_name
}

output "rds_id" {
  description = "The ID of the instance"
  value       = aws_db_instance.dev_db.id
}



output "db_user" {
  description = "Database master username"
  value       = aws_db_instance.dev_db.username
  sensitive   = true
}

output "db_password" {
  description = "Database master password"
  value       = aws_db_instance.dev_db.password
  sensitive   = true
}
