terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}



# Launch template



resource "aws_launch_template" "wordpress" {
  name_prefix   = "wordpress-lt-"
  image_id      = var.wordpress_ami_id
  instance_type = var.instance_type

  # 1. IDENTITY: Who is this server?
  iam_instance_profile {
    arn = var.iam_wp_pf_arn
  }

  network_interfaces {


    associate_public_ip_address = false
    security_groups             = [var.wp_app_sg_id]

  }


  # 3. ACCESS: How do we debug it?
  key_name = var.ec2_key_name

  # 4. BRAINS: The Cloud-Init Configuration
  # We inject the EFS ID directly from the resource in persistence.tf
  user_data = base64encode(templatefile("${path.module}/user_data.yaml", {
    efs_id      = var.wp_efs_id
    db_name     = var.database_name
    db_user     = var.db_user
    db_password = var.db_password
    db_host     = var.rds_endpoint
    domain_name = var.domain_name
    # Use simple placeholders for keys
  auth_key          = "${random_id.wp_keys.hex}-auth"
  secure_auth_key   = "${random_id.wp_keys.hex}-secure"
  logged_in_key     = "${random_id.wp_keys.hex}-logged"
  nonce_key         = "${random_id.wp_keys.hex}-nonce"
  auth_salt         = "${random_id.wp_keys.hex}-auth-salt"
  secure_auth_salt  = "${random_id.wp_keys.hex}-secure-salt"
  logged_in_salt    = "${random_id.wp_keys.hex}-logged-salt"
  nonce_salt        = "${random_id.wp_keys.hex}-nonce-salt" 
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

resource "random_id" "wp_keys"{
  byte_length = 32    
}
resource "aws_autoscaling_group" "wordpress" {
  name                = "wordpress-asg"
  vpc_zone_identifier = values(var.private_subnet_id_app)
  desired_capacity    = 2
  max_size            = 3
  min_size            = 1

  launch_template {
    id      = aws_launch_template.wordpress.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 90
    }
  }

  tag {
    key                 = "Name"
    value               = "WordPress-Instance"
    propagate_at_launch = true
  }
}
