variable "db_allocated_storage" {
  description = "The amount of storage needed"
  type        = number
  default     = 20
}

variable "db_instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "The name of the database to create"
  type        = string
  default     = "wordpress" # Simple, valid database name
}

variable "project_name" {
  description = "Name of the project, used for tagging and naming resources"
  type        = string
  default     = "wordpress" # or whatever you want to call your project
}

variable "db_username" {
  description = "The master username for the database"
  type        = string
  default     = "wp_master"
}
