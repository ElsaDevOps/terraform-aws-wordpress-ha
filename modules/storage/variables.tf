variable "project_name" {
  description = "Name of the project, used for tagging and naming resources"
  type        = string
  default     = "wordpress" # or whatever you want to call your project
}

variable "subnet_ids" {
  description = "the subnet id's from vpc module"
  type        = map(string)
}


variable "efs_sg_id" {
  description = "the ID of the EFS sg"
  type        = string

}

variable "wp_efs_id" {
  description = "the ID of the EFS"
  type        = string

}
