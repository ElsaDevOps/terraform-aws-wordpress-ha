variable "ec2_key_name" {
  description = "Emergency access key for ssh"
  type        = string
}

variable "instance_type" {
  type        = string
  description = "instance type"
  default     = "t3.micro"
}

variable "wordpress_ami_id" {
  type        = string
  description = "The ID of the AMI"
}

variable "wp_efs_id" {
  type        = string
  description = "the EFS ID"
}

variable "iam_wp_pf_arn" {
  type        = string
  description = "The value of the iam instance profile arn"
}

variable "wp_app_sg_id" {
  type        = string
  description = "The ID of the app sg"

}

variable "private_subnet_id_app" {
  description = "The Id of the public subnet"
  type        = map(string)

}




variable "database_name" {
  description = "WordPress database name"
  type        = string
}

variable "db_username" {
  description = "WordPress database username"
  type        = string
}

variable "db_password" {
  description = "WordPress database password"
  type        = string
  sensitive   = true
}

variable "rds_endpoint" {
  description = "RDS database endpoint"
  type        = string
}

variable "domain_name" {
  description = "the domain name"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "wordpress"
}
