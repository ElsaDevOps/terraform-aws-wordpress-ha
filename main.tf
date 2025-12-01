# VPC Module
module "vpc" {
  source = "./modules/vpc"

  cidr_blockvpc            = var.cidr_blockvpc
  cidr_public_subnet_web   = var.cidr_public_subnet_web
  cidr_private_subnet_app  = var.cidr_private_subnet_app
  cidr_private_subnet_data = var.cidr_private_subnet_data
  availability_zones       = var.availability_zones


}

#Database module

module "database" {
  source               = "./modules/database"
  subnet_ids           = module.vpc.private_subnet_id_data
  rds_sg_id            = module.security.rds_sg_id
  db_username          = var.db_username
  project_name         = var.project_name
  db_instance_class    = var.db_instance_class
  db_allocated_storage = var.db_allocated_storage
  db_name              = var.db_name



}

# Security group module
module "security" {
  source = "./modules/security"
  vpc_id = module.vpc.vpc_id



}
