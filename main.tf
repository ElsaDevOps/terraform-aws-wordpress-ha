# VPC Module
module "vpc" {
  source = "./modules/vpc"

  cidr_blockvpc            = local.network_config.cidr_vpc
  cidr_public_subnet_web   = local.network_config.cidr_public_subnet_web
  cidr_private_subnet_app  = local.network_config.cidr_private_subnet_app
  cidr_private_subnet_data = local.network_config.cidr_private_subnet_data
  availability_zones       = local.network_config.availability_zones
}

# Security module
module "security" {
  source = "./modules/security"

  vpc_id = module.vpc.vpc_id
}

# Database module
module "database" {
  source = "./modules/database"

  subnet_ids           = module.vpc.private_subnet_id_data
  rds_sg_id            = module.security.rds_sg_id
  db_username          = local.database_config.username
  project_name         = local.project_name
  db_instance_class    = local.database_config.instance_class
  db_allocated_storage = local.database_config.allocated_storage
  database_name        = local.database_config.name
}

# IAM module
module "IAM" {
  source = "./modules/iam"
}

# AMI module
module "AMI" {
  source = "./modules/ami"
}

# Storage Module
module "storage" {
  source     = "./modules/storage"
  subnet_ids = module.vpc.private_subnet_id_data
  efs_sg_id  = module.security.efs_sg_id
}

# Compute Module
module "Compute" {
  source = "./modules/compute"

  ec2_key_name          = local.compute_config.key_name
  wordpress_ami_id      = module.AMI.wordpress_ami_id
  wp_efs_id             = module.storage.wp_efs_id
  iam_wp_pf_arn         = module.IAM.iam_wp_pf_arn
  wp_app_sg_id          = module.security.wp_app_sg_id
  private_subnet_id_app = module.vpc.private_subnet_id_app
  database_name         = module.database.database_name
  db_username           = module.database.db_username
  db_password           = module.database.db_password
  rds_endpoint          = module.database.rds_endpoint
  domain_name           = var.domain_name
  project_name          = var.project_name

}

# Loadbalancer module
module "Loadbalancer" {
  source               = "./modules/loadbalancer"
  wp_alb_sg_id         = module.security.wp_alb_sg_id
  vpc_id               = module.vpc.vpc_id
  public_subnet_id_web = module.vpc.public_subnet_id_web
  wp_asg_id            = module.Compute.wp_asg_id
  domain_name          = var.domain_name
  wildcard_domain      = local.wildcard_domain
}
