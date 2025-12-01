variable "ec2_key_name" {
  description = "Emergency access key for ssh"
  type        = string
}

variable "instance_type" {
  type        = string
  description = "instance type"
  default     = "t2.micro"
}
