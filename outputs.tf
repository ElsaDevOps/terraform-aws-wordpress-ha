output "vpc_id" {
  description = "ID of my VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "CIDR block on VPC"
  value       = module.vpc.vpc_cidr_block
}

output "private_subnet_id_app" {
  description = "Map of private app tier subnet IDs, keyed by AZ's"
  value       = values(module.vpc.private_subnet_id_app)
}


output "private_subnet_id_data" {
  description = "Map of private data tier subnet IDs, keyed by AZ's"
  value       = values(module.vpc.private_subnet_id_data)
}

output "public_subnet_id_web" {
  description = "Map of public web tier subnet IDs, keyed by AZ's"
  value       = values(module.vpc.public_subnet_id_web)
}

output "rds_endpoint" {
  description = "The connection endpoint for the RDS instance"
  value       = module.database.rds_endpoint
}

output "database_name" {
  description = "The name of the database"
  value       = module.database.database_name
}

output "wp_efs_id" {
  description = "The ID of the EFS"
  value       = module.storage.wp_efs_id
}
