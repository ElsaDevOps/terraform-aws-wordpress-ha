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

variable "public_subnet_id_web" {
  description = "The Id of the public subnet"
  type        = map(string)

}
