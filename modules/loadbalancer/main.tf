terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

resource "aws_lb" "wp_alb" {
  name                       = "wp-alb-tf"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [var.wp_alb_sg_id]
  subnets                    = values(var.public_subnet_id_web)
  idle_timeout               = 300
  drop_invalid_header_fields = true

  #   enable_deletion_protection = true

  #   access_logs {
  #     bucket  = aws_s3_bucket.lb_logs.id
  #     prefix  = "wp-lb"
  #     enabled = true
  #   }

  tags = {
    Name        = "${var.project_name}-alb"
    Project     = var.project_name
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

resource "aws_lb_target_group" "wp_alb_tg" {
  name                 = "tf-wp-lb-tg"
  target_type          = "instance"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = 300

  stickiness {
    type            = "lb_cookie"
    cookie_duration = 86400
    enabled         = true
  }

  health_check {
    enabled             = true
    interval            = 30
    timeout             = 5
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
    type = "redirect"


    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
      host        = "#{host}"
      path        = "/#{path}"
      query       = "#{query}"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.wp_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate_validation.cert.certificate_arn
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wp_alb_tg.arn
  }
}

resource "aws_lb_listener_rule" "redirect_root_to_www" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 1

  action {
    type = "redirect"

    redirect {
      host        = var.domain_name
      path        = "/#{path}"
      query       = "#{query}"
      port        = "#{port}"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    host_header {
      values = [var.domain_name]
    }
  }
}


resource "aws_autoscaling_attachment" "example" {
  autoscaling_group_name = var.wp_asg_id
  lb_target_group_arn    = aws_lb_target_group.wp_alb_tg.arn
}


resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  subject_alternative_names = [
    var.wildcard_domain

  ]



  lifecycle {
    create_before_destroy = true
  }
}

data "aws_route53_zone" "main" {
  name         = var.domain_name
  private_zone = false
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  zone_id         = data.aws_route53_zone.main.zone_id
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

# Existing www record (you'll import this)
resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_lb.wp_alb.dns_name
    zone_id                = aws_lb.wp_alb.zone_id
    evaluate_target_health = true
  }
}

# New root domain record (Terraform will create this)
resource "aws_route53_record" "root" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_lb.wp_alb.dns_name
    zone_id                = aws_lb.wp_alb.zone_id
    evaluate_target_health = true
  }
}
