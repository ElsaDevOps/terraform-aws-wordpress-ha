terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
resource "aws_db_subnet_group" "rds" {
  name       = "wordpress-rds-sng"
  subnet_ids = values(var.subnet_ids)

  tags = {
    Name        = "${var.project_name}-db-subnet-group"
    Project     = var.project_name
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

resource "aws_db_instance" "dev_db" {
  identifier = "wordpress-dev-db"


  engine         = "mysql"
  engine_version = "8.0"
  instance_class = var.db_instance_class


  allocated_storage = var.db_allocated_storage
  storage_type      = "gp2"


  db_name  = var.database_name
  username = var.db_username
  password = data.aws_ssm_parameter.db_password.value


  db_subnet_group_name       = aws_db_subnet_group.rds.name
  vpc_security_group_ids     = [var.rds_sg_id]
  publicly_accessible        = false
  multi_az                   = true # Multi-AZ for high availability
  storage_encrypted          = true # Encryption at rest using AWS-managed key (free)
  backup_retention_period    = 7    # 7-day backup retention for point-in-time recovery
  auto_minor_version_upgrade = true
  copy_tags_to_snapshot      = true




  skip_final_snapshot = true
  deletion_protection = true

  tags = {
    Name        = "${var.project_name}-database"
    Project     = var.project_name
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

data "aws_ssm_parameter" "db_password" {
  name            = "/wordpress/aurora/master-password"
  with_decryption = true
}
