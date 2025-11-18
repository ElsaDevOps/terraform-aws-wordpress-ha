output "vpc_id" {
  description = "ID of my VPC"
  value       = aws_vpc.my_vpc.id
}

output "vpc_cidr_block" {
  description = "CIDR block on VPC"
  value       = aws_vpc.my_vpc.cidr_block
}

output "private_subnet_id_app" {
  description = "List of private app tier subnet IDs"
  value       = [for subnet in values(aws_subnet.private_subnet_app) : subnet.id]
}


output "private_subnet_id_data" {
  description = "List of private data tier subnet IDs"
  value       = [for subnet in values(aws_subnet.private_subnet_data) : subnet.id]
}

output "public_subnet_id_web" {
  description = "List of public web tier subnet IDs"
  value       = [for subnet in values(aws_subnet.public_subnet) : subnet.id]
}