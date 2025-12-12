terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}


resource "aws_security_group" "ec2-compute" {
  name        = "wordpress-ec2-compute-sg"
  description = "Allow traffic to and from the WordPress EC2 instances"
  vpc_id      = var.vpc_id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-ec2-sg"
    Project     = var.project_name
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

resource "aws_security_group_rule" "allow_alb_traffic_http" {
  description              = "Allow HTTP traffic from ALB to EC2"
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.wp_app_sg.id
  source_security_group_id = aws_security_group.wp_alb_sg.id
}



resource "aws_security_group" "rds" {
  description = "Security group for RDS database"
  name        = "${var.project_name}-rds-sg"
  vpc_id      = var.vpc_id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-rds-sg"
    Project     = var.project_name
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

resource "aws_security_group_rule" "allow_MySQL" {
  description              = "Allow MySQL traffic from compute instances"
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds.id
  source_security_group_id = aws_security_group.wp_app_sg.id
}

# Wordpress app tier security group

resource "aws_security_group" "wp_app_sg" {
  name        = "wordpress-app-sg"
  description = "security group for wordpress app instances"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }




  tags = {
    Name        = "${var.project_name}-app-sg"
    Project     = var.project_name
    Environment = "dev"
    ManagedBy   = "Terraform"
  }

}

resource "aws_security_group_rule" "allow_egress_rds" {
  description              = "Allow egress traffic from RDS"
  type                     = "egress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.wp_app_sg.id
  source_security_group_id = aws_security_group.rds.id
}

resource "aws_security_group_rule" "allow_NFS" {
  description              = "Allow NFS traffic from compute to EFS"
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  security_group_id        = aws_security_group.efs_sg.id
  source_security_group_id = aws_security_group.wp_app_sg.id
}

# EFS Security group

resource "aws_security_group" "efs_sg" {
  description = "Security group for EFS file system"
  name        = "efs-sg"
  vpc_id      = var.vpc_id




  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]


  }
  tags = {
    Name        = "${var.project_name}-efs-sg"
    Project     = var.project_name
    Environment = "dev"
    ManagedBy   = "Terraform"
  }


}

resource "aws_security_group" "wp_alb_sg" {
  name        = "wordpress-alb-sg"
  description = "Security group for WordPress ALB"
  vpc_id      = var.vpc_id


  # EGRESS: Allow All Outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-alb-sg"
    Project     = var.project_name
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}


resource "aws_security_group_rule" "allow_http_traffic" {
  description       = "Allow HTTP traffic from internet to ALB"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.wp_alb_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_https_traffic" {
  description       = "Allow HTTPS traffic from internet to ALB"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.wp_alb_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}
