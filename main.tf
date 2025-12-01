# VPC Module
module "vpc" {
  source = "./modules/vpc"

  cidr_blockvpc            = var.cidr_blockvpc
  cidr_public_subnet_web   = var.cidr_public_subnet_web
  cidr_private_subnet_app  = var.cidr_private_subnet_app
  cidr_private_subnet_data = var.cidr_private_subnet_data
  availability_zones       = var.availability_zones


}



#Creating Custom VPC

resource "aws_vpc" "my_vpc" {
  cidr_block           = var.cidr_blockvpc
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  tags = {
    Name = "my_vpc"
  }
}


# # Create Public and Private Subnets

# Public subnet web tier

resource "aws_subnet" "public_subnet" {
  for_each                = { for i, availability_zone in var.availability_zones : availability_zone => var.cidr_public_subnet_web[i] }
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = {
    Name = "Public subnet web"
  }
}
