terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# compute.tf

resource "aws_launch_template" "wordpress" {
  name_prefix   = "wordpress-lt-"
  image_id      = var.wordpress_ami_id
  instance_type = var.instance_type

  # 1. IDENTITY: Who is this server?
  iam_instance_profile {
    arn = var.iam_wp_pf_arn
  }

  # 2. SECURITY: Who can talk to it?
  vpc_security_group_ids = [var.wp_app_sg_id]

  # 3. ACCESS: How do we debug it?
  key_name = var.ec2_key_name

  # 4. BRAINS: The Cloud-Init Configuration
  # We inject the EFS ID directly from the resource in persistence.tf
  user_data = base64encode(templatefile("${path.module}/user_data.yaml", {
    efs_id = var.wp_efs_id
  }))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "WordPress-Instance"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "wordpress" {
  name                = "wordpress-asg"
  vpc_zone_identifier = values(var.public_subnet_id_web)
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1

  launch_template {
    id      = aws_launch_template.wordpress.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "WordPress-Instance"
    propagate_at_launch = true
  }
}
