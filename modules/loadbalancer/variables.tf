variable "wp_alb_sg_id" {
  description = "the ID of the ALB sg"
  type        = string

}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string

}

variable "public_subnet_id_web" {
  description = "The Id of the public subnet"
  type        = map(string)

}

variable "wp_asg_id" {
  description = "The ID of the asg"
  type        = string
}
