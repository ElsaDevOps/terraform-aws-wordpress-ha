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

variable "instance_type" {
  type        = string
  description = "instance type"
  default     = "t2.micro"
}

variable "instance_ami" {
  type        = string
  description = "ami"
  default     = "ami-075599e9cc6e3190d"
}

variable "region" {
  type        = string
  description = "Aws region"
  default     = "eu-west-2"
}

variable "availability_zones" {
  type        = list(string)
  description = "The availability zones to deploy to"
  default     = ["eu-west-2a", "eu-west-2b"]
}

  
 variable "vpc_id" {
  description = "The ID of the VPC where all resources will be deployed."
  type        = string
  
}


variable "db_name" {
  description = "The name of the initial database to be created in the Aurora cluster."
  type        = string
  default     = "wordpressdb"
}

variable "db_master_username" {
  description = "The master username for the Aurora database."
  type        = string
  default     = "admin"
}

variable "db_instance_class" {
  description = "The instance class to use for the Aurora database instances."
  type        = string
  default     = "db.t3.micro"
}

variable "private_data_subnet_ids" {
  description = "A list of private subnet IDs for the data layer (Aurora, EFS)."
  type        = list(string)
}

variable "db_name_1" {
  description = "The name of the initial database to be created in the Aurora cluster."
  type        = string
  default     = "wordpress_db"
}

variable "db_username" {
  description = "The master username for the Aurora database."
  type        = string
  default     = "dbadmin"
}

variable "db_instance_class_aurora" {
  description = "The instance class for the Aurora database instances."
  type        = string
  default     = "db.t3.medium"
}

variable "project_name" {
  description = "A unique name for the project to prefix resources."
  type        = string
  default     = "wp-ha" 
}

variable "db_allocated_storage" {
  description = "The amount of storage in GB for the RDS instance."
  type        = number
  default     = 20
}

