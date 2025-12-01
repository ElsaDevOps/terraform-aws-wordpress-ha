resource "aws_lb" "wp_alb" {
  name               = "wp-alb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.wp_alb_sg.id]
  subnets            = values(module.vpc.public_subnet_id_web)

  #   enable_deletion_protection = true

  #   access_logs {
  #     bucket  = aws_s3_bucket.lb_logs.id
  #     prefix  = "wp-lb"
  #     enabled = true
  #   }

  tags = {
    Environment = "development"
  }
}

resource "aws_lb_target_group" "wp_alb_tg" {
  name        = "tf-wp-lb-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id

  health_check {
    enabled             = true
    interval            = 35
    timeout             = 30
    matcher             = "200,302"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
  }


}


resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.wp_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wp_alb_tg.arn
  }

}

resource "aws_autoscaling_attachment" "example" {
  autoscaling_group_name = aws_autoscaling_group.wordpress.id
  lb_target_group_arn    = aws_lb_target_group.wp_alb_tg.arn
}
