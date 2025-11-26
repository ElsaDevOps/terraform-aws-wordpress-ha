output "vpc_id" {
  description = "ID of my VPC"
  value       = aws_vpc.my_vpc.id
}

output "vpc_cidr_block" {
  description = "CIDR block on VPC"
  value       = aws_vpc.my_vpc.cidr_block
}

# output "private_subnet_id_app" {
#   description = "Map of private app tier subnet IDs, keyed by AZ's"
#   value = {
#     for az, subnet in aws_subnet.private_subnet_app : az => subnet.id
#   }
# }


# output "private_subnet_id_data" {
#   description = "Map of private data tier subnet IDs, keyed by AZ's"
#   value = {
#     for az, subnet in aws_subnet.private_subnet_data : az => subnet.id
#   }
# }

output "public_subnet_id_web" {
  description = "Map of public web tier subnet IDs, keyed by AZ's"
  value = {
    for az, subnet in aws_subnet.public_subnet : az => subnet.id
  }
}

output "rds_endpoint" {
  description = "The connection endpoint for the RDS instance"
  value       = aws_db_instance.dev_db.endpoint
}

output "database_name" {
  description = "The name of the database"
  value       = aws_db_instance.dev_db.db_name
}