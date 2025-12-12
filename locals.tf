locals {
  # Network configuration - used by multiple modules
  network_config = {
    cidr_vpc                 = var.cidr_blockvpc
    cidr_public_subnet_web   = var.cidr_public_subnet_web
    cidr_private_subnet_app  = var.cidr_private_subnet_app
    cidr_private_subnet_data = var.cidr_private_subnet_data
    availability_zones       = var.availability_zones
  }

  # Database configuration - keeps related settings together
  database_config = {
    username          = var.db_username
    instance_class    = var.db_instance_class
    allocated_storage = var.db_allocated_storage
    name              = var.database_name
  }

  # Compute configuration
  compute_config = {
    key_name = var.ec2_key_name
  }


  root_domain = replace(var.domain_name, "www", "")
  wildcard_domain = "*${local.root_domain}"
  project_name = var.project_name
}
