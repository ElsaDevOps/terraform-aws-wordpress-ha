# AWS AMI
# data "aws_ami" "amazon_linux_2023" {
#   most_recent = true
#   owners      = ["amazon"]

#   filter {
#     name   = "name"
#     values = ["al2023-ami-2023.*-x86_64"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
# }


# resource "aws_launch_template" "wordpress-lt" {
#   name = "Wordpress-lt"
#   image_id        = data.aws_ami.amazon_linux_2023.id
#   instance_type   = "t2.micro"
#   user_data       = base64encode(templatefile("${path.module}/user_data.yaml", {
#   file_system_id = aws_efs_file_system.wp_efs.id
#   }))
#   vpc_security_group_ids = #TBD
#   key_name = var.ec2_key_name

  
#   lifecycle {
#     create_before_destroy = true
#   }

#   tag_specifications {
#     resource_type = "instance"
#     tags = {
#       Name = "WordPress-Compute"
#     }
#   }
# }



