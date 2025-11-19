resource "aws_launch_template" "wordpress" {
  name_prefix = "wordpress-"
  image_id      = data.aws_ami.amazon_linux_2023.id
  instance_type = var.instance_type
  iam_instance_profile {
    arn = aws_iam_instance_profile.wp_profile.arn

  }
  vpc_security_group_ids = [aws_security_group.ec2-compute.id]
  key_name = var.ec2_key_name
    user_data = base64encode(templatefile("${path.module}/user_data.yaml", {
    efs_id = var.efs_fs_id
  }))
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "WordPress Instance"
    }
  }

  lifecycle {
    create_before_destroy = true
  }


  
}