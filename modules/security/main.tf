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
    Name = "WordPress EC2 SG"
  }
}

resource "aws_security_group_rule" "allow_alb_traffic_http" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.wp_app_sg.id
  source_security_group_id = aws_security_group.wp_alb_sg.id
}



resource "aws_security_group" "rds" {
  name        = "${var.project_name}-rds-sg"
  description = "Security group for RDS database"
  vpc_id      = var.vpc_id
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

resource "aws_security_group_rule" "allow_MySQL" {
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
    Name = "wordpress-app-sg"
  }

}

resource "aws_security_group_rule" "allow_egress_rds" {
  type                     = "egress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.wp_app_sg.id
  source_security_group_id = aws_security_group.rds.id
}

resource "aws_security_group_rule" "allow_NFS" {
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  security_group_id        = aws_security_group.efs_sg.id
  source_security_group_id = aws_security_group.wp_app_sg.id
}

# EFS Security group

resource "aws_security_group" "efs_sg" {
  name        = "efs-sg"
  description = "Allow NFS access"
  vpc_id      = var.vpc_id




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
  vpc_id      = var.vpc_id


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


resource "aws_security_group_rule" "allow_http_traffic" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.wp_alb_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_https_traffic" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.wp_alb_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}
