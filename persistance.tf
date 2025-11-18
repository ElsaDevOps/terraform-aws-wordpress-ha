resource "aws_efs_file_system" "wp_efs" {
  creation_token = "wordpress-efs-token"

  tags = {
    Name = "wordpress-efs"
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

resource "aws_efs_mount_target" "alpha" {
  for_each        = module.vpc.private_subnet_id_data
  file_system_id  = aws_efs_file_system.wp_efs.id
  subnet_id       = each.value
  security_groups = [aws_security_group.efs_sg.id]
}
