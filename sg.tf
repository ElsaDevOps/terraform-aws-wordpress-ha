# Security groups




# resource "aws_security_group" "ec2-compute" {
#   name        = "wordpress-ec2-compute-sg"
#   description = "Allow traffic to and from the WordPress EC2 instances"
#   vpc_id      = module.vpc.vpc_id

# #   ingress {
# #     protocol  = "tcp"
# #     from_port = 443
# #     to_port   = 443
# #     security_groups = [aws_security_group.wp_lb_sg.id]
# #   }


#   ingress {
#     description = "Allow HTTP from Anywhere for testing"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#     description = "Allow outbount HTTPS to the Internet"
# }

# egress {
#     from_port       = 2049
#     to_port         = 2049
#     protocol        = "tcp"
#     security_groups = [var.efs_sg_id]
#     description     = "Allow outbound to EFS"
#   }

#    egress {
#     from_port       = 3306
#     to_port         = 3306
#     protocol        = "tcp"
#     security_groups = [var.aurora_sg_id]
#     description     = "Allow outbound to Aurora DB"
  
  
 

# }

#  tags = {
#     Name = "WordPress EC2 SG"
#   }


# }


resource "aws_security_group" "ec2-compute" {
  name        = "wordpress-ec2-compute-sg"
  description = "Allow traffic to and from the WordPress EC2 instances"
  vpc_id      = module.vpc.vpc_id # Keep this as is since it seems to be working for you

  # INGRESS: Allow HTTP from Anywhere (for verification today)
  ingress {
    description = "Allow HTTP from Anywhere for testing"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # EGRESS: Allow All Outbound
  # This allows the instance to reach EFS, Aurora, AND the internet for updates.
  # We control security at the EFS/DB level (Ingress), not here.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # "-1" means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "WordPress EC2 SG"
  }
}