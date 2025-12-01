


resource "aws_security_group" "ec2-compute" {
  name        = "wordpress-ec2-compute-sg"
  description = "Allow traffic to and from the WordPress EC2 instances"
  vpc_id      = module.vpc.vpc_id

  # INGRESS: Allow traffic from ALB
  ingress {
    description     = "Allow traffic from ALB only"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.wp_alb_sg.id]
  }



  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "WordPress EC2 SG"
  }
}

resource "aws_security_group" "rds" {
  name        = "${var.project_name}-rds-sg"
  description = "Security group for RDS database"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "MySQL from EC2 instances"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2-compute.id] # Only from EC2, not from internet
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-rds-sg"
  }
}

# Wordpress app tier secuirty group

resource "aws_security_group" "wp_app_sg" {
  name        = "wordpress-app-sg"
  description = "security group for wordpress app instances"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }


  tags = {
    Name = "wordpress-efs-sg"
  }

}

# EFS Security group

resource "aws_security_group" "efs_sg" {
  name        = "efs-sg"
  description = "Allow NFS access"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "NFS from App SG"
    protocol    = "tcp"
    from_port   = 2049
    to_port     = 2049

    security_groups = [aws_security_group.wp_app_sg.id]
  }



  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]


  }
  tags = {
    Name = "efs-sg"
  }


}

resource "aws_security_group" "wp_alb_sg" {
  name        = "wordpress-alb-sg"
  description = "Allow the ALB to recieve ingress traffic"
  vpc_id      = module.vpc.vpc_id

  # INGRESS: Allow HTTPS and HTTP from Anywhere
  ingress {
    description = "Allow HTTP from Anywhere for testing"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS from Anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # EGRESS: Allow All Outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "WordPress ALB SG"
  }
}
