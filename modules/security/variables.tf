variable "project_name" {
  description = "Name of the project, used for tagging and naming resources"
  type        = string
  default     = "wordpress" # or whatever you want to call your project
}


variable "vpc_id" {
  description = "The vpc ID for the sg to use."
  type        = string
}
