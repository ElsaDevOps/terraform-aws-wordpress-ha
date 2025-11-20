# VPC Module
module "vpc" {
  source = "./modules/vpc"


}

# EC2 instances for Wordpress

# resource "aws_instance" "wordpress_instance" {
#   ami                     = var.instance_ami
#   instance_type           = var.instance_type
#   subnet_id = aws_subnet.private_subnet_app.id
#   region = var.region
#   for_each = toset(var.availability_zones)
#   availability_zone = each.value
#   vpc_security_group_ids = [aws_security_group.http-sg.id]

# }

# resource "aws_instance" "wordpress_instance_2" {
#   ami                     = "ami-075599e9cc6e3190d"
#   instance_type           = "var.instance_type"
#   subnet_id = aws_subnet.private_subnet_app.id
#   region = var.region
#   availability_zone = each.value
#   vpc_security_group_ids = [aws_security_group.http-sg.id]

# }


# # Security groups

# resource "aws_security_group" "http-sg" {
#   name        = "http-sg"
#   description = "Allow HTTP access"
#   vpc_id      = aws_vpc.my_vpc.id

#   ingress {
#     protocol  = "tcp"
#     self      = true
#     from_port = 80
#     to_port   = 80
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
# }

# }


# resource "aws_security_group" "ssh-sg" {
#   name        = "ssh-sg"
#   description = "Allow SSH access"
#   vpc_id      = aws_vpc.my_vpc.id

#   ingress {
#     protocol  = "tcp"
#     self      = true
#     from_port = 22
#     to_port   = 22
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]


# }

# }



# #RDS Databases

# resource "aws_db_instance" "default" {
#   allocated_storage    = 10
#   db_name              = "mydb"
#   engine               = "mysql"
#   engine_version       = "8.0"
#   instance_class       = "db.t3.micro"
#   username             = "foo"
#   password             = "foobarbaz"
#   parameter_group_name = "default.mysql8.0"
#   skip_final_snapshot  = true
# }

# resource "aws_db_instance" "default" {
#   allocated_storage    = 10
#   db_name              = "mydb"
#   engine               = "mysql"
#   engine_version       = "8.0"
#   instance_class       = "db.t3.micro"
#   username             = "foo"
#   password             = "foobarbaz"
#   parameter_group_name = "default.mysql8.0"
#   skip_final_snapshot  = true
# }

# #application load balancer

#  resource "aws_lb" "test" {
#   name               = "test-lb-tf"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.lb_sg.id]
#   subnets            = [for subnet in aws_subnet.public : subnet.id]

#   enable_deletion_protection = true

#   access_logs {
#     bucket  = aws_s3_bucket.lb_logs.id
#     prefix  = "test-lb"
#     enabled = true
#   }

#   tags = {
#     Environment = "production"
#   }
# }

# # Listener, target group

# resource "aws_lb_target_group" "front_end" {
#   name     = "tf-example-lb-tg"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.my_vpc.id
# }

# resource "aws_lb_listener" "front_end" {
#   load_balancer_arn = aws_lb.front_end.arn
#   port              = "443"
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.front_end.arn
#   }
# }


# Auto scaling groups

#Creating Custom VPC

resource "aws_vpc" "my_vpc" {
  cidr_block           = var.cidr_blockvpc
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  tags = {
    Name = "my_vpc"
  }
}


# # Create Public and Private Subnets

# Public subnet web tier

resource "aws_subnet" "public_subnet" {
  for_each                = { for i, availability_zone in var.availability_zones : availability_zone => var.cidr_public_subnet_web[i] }
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = {
    Name = "Public subnet web"
  }
}




# private subnet app tier

resource "aws_subnet" "private_subnet_app" {
  for_each                = { for i, availability_zone in var.availability_zones : availability_zone => var.cidr_private_subnet_app[i] }
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = false

  tags = {
    Name = "Private subnet app"
  }
}



#private subnet data tier

resource "aws_subnet" "private_subnet_data" {
  for_each                = { for i, availability_zone in var.availability_zones : availability_zone => var.cidr_private_subnet_data[i] }
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = false

  tags = {
    Name = "Private subnet data"
  }
}

