# resource "aws_db_subnet_group" "aurora" {
#   name       = "wordpress-aurora-sng"
#   subnet_ids = var.private_data_subnet_ids

#   tags = {
#     Name = "My DB subnet group"
#   }
# }

# resource "aws_db_instance" "dev_db" {
#   identifier = "wordpress-dev-db"

#   # --- Instance & Engine Configuration ---
#   engine         = "mysql"
#   engine_version = "8.0"                 # A current, stable MySQL version
#   instance_class = var.db_instance_class # This must be "db.t3.micro" for Free Tier

#   # --- Storage Configuration ---
#   allocated_storage = var.db_allocated_storage # This should be 20 for Free Tier
#   storage_type      = "gp2"                    # General Purpose SSD

#   # --- Database Credentials & Naming ---
#   db_name  = var.db_name
#   username = var.db_username
#   password = data.aws_ssm_parameter.db_password.value

#   # --- Network & Security ---
#   db_subnet_group_name   = aws_db_subnet_group.aurora.name
#   vpc_security_group_ids = [aws_security_group.aurora.id]
#   publicly_accessible    = false # CRITICAL: Never expose a DB to the internet

#   # --- Backup & Safety (Dev-Specific Settings) ---
#   # For production, these should be more robust.
#   backup_retention_period = 0     # Disable automated backups for dev to save cost
#   skip_final_snapshot     = true  # Don't create a snapshot when we destroy it
#   deletion_protection     = false # Allow easy destruction of this dev instance

#   tags = {
#     Name = "${var.project_name}-dev-db"
#   }
# }

# data "aws_ssm_parameter" "db_password" {
#   name            = "/wordpress/aurora/master-password"
#   with_decryption = true
# }  