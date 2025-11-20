
resource "aws_security_group" "ec2-compute" {
  name        = "wordpress-ec2-compute-sg"
  description = "Allow traffic to and from the WordPress EC2 instances"
  vpc_id      = var.vpc_id



  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow outbount HTTPS to the Internet"
  }

  egress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.efs.id]
    description     = "Allow outbound to EFS"
  }

  tags = {
    Name = "WordPress EC2 SG"
  }

}

resource "aws_security_group" "aurora" {
  name        = "wordpress-aurora-db-sg"
  description = "Security group for the Aurora database cluster"
  vpc_id      = var.vpc_id

  tags = {
    Name = "WordPress Aurora SG"
  }
}

resource "aws_security_group_rule" "allow_ec2_to_aurora" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.aurora.id      # The destination
  source_security_group_id = aws_security_group.ec2-compute.id # The source
  description              = "Allow inbound MySQL from EC2 instances"
}

resource "aws_security_group_rule" "ec2_to_aurora_egress" {
  type                     = "egress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ec2-compute.id # The source
  source_security_group_id = aws_security_group.aurora.id      # The destination
  description              = "Allow EC2 to talk to Aurora"
}

resource "aws_security_group" "efs" {
  name        = "${var.project_name}-efs-sg"
  description = "Allow NFS traffic from the EC2 instances"
  vpc_id      = var.vpc_id # We need to make sure vpc_id is a defined variable

  tags = {
    Name = "${var.project_name}-efs-sg"
  }
}