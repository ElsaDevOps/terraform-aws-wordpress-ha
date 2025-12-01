output "rds_endpoint" {
  description = "The connection endpoint for the RDS instance"
  value       = aws_db_instance.dev_db.endpoint
}

output "database_name" {
  description = "The name of the database"
  value       = aws_db_instance.dev_db.db_name
}
