variable "cidr_blockvpc" {
  type        = string
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}
variable "cidr_private_subnet_app" {
  type        = list(string)
  description = "CIDR blocks for private subnets on the app tier"
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "cidr_private_subnet_data" {
  type        = list(string)
  description = "CIDR blocks for private subnets on the data tier"
  default     = ["10.0.201.0/24", "10.0.202.0/24"]
}

variable "cidr_public_subnet_web" {
  type        = list(string)
  description = "CIDR blocks for public subnets on the web tier"
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}


# tflint-ignore: terraform_unused_declarations
variable "instance_type" {
  type        = string
  description = "instance type"
  default     = "t2.micro"
}

# variable "region" {
#   type        = string
#   description = "Aws region"
#   default     = "eu-west-2"
# }

variable "availability_zones" {
  type        = list(string)
  description = "The availability zones to deploy to"
  default     = ["eu-west-2a", "eu-west-2b"]
}





# tflint-ignore: terraform_unused_declarations
variable "ec2_key_name" {
  description = "Emergency access key for ssh"
  type        = string
}




variable "db_instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "The amount of storage needed"
  type        = number
  default     = 20
}



# Add this one
variable "db_name" {
  description = "The name of the database to create"
  type        = string
  default     = "wordpress" # Simple, valid database name
}

# tflint-ignore: terraform_unused_declarations
variable "project_name" {
  description = "Name of the project, used for tagging and naming resources"
  type        = string
  default     = "wordpress"
}

# tflint-ignore: terraform_unused_declarations
variable "db_username" {
  description = "The master username for the database"
  type        = string
  default     = "wp_master"
}

variable "domain_name" {
  description = "the domain name"
  type        = string
}


# tflint-ignore: terraform_unused_declarations
