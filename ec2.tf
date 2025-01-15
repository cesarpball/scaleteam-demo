resource "aws_lb" "scale" {
  name                       = "${var.project_name}-alb"
  internal                   = var.scale_alb_internal
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.sg_alb.id]
  subnets                    = module.vpc.public_subnets
  idle_timeout               = var.scale_alb_timeout
  enable_deletion_protection = var.scale_alb_enable_deletion_protection
  tags                       = var.default_tags

}

resource "aws_lb_target_group" "scale" {

  name        = "${var.project_name}-tg"
  port        = var.scale_tg_port
  protocol    = var.scale_tg_protocol
  target_type = "ip"
  vpc_id      = module.vpc.vpc_id

  health_check {
    port                = var.scale_health_check_port
    protocol            = var.scale_health_check_protocol
    path                = var.scale_health_check_path
    healthy_threshold   = var.scale_health_check_healthy_threshold
    unhealthy_threshold = var.scale_health_check_unhealthy_threshold
    interval            = var.scale_health_check_interval

  }
  tags = var.default_tags

}

#443 a certificate is needed with HTTPs protocol
resource "aws_lb_listener" "scale" {
  load_balancer_arn = aws_lb.scale.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.scale.arn
  }
  tags = var.default_tags

}


resource "aws_security_group" "sg_alb" {
  name        = "${var.project_name}-alb-sg"
  description = "Allow Traffic"
  vpc_id      = module.vpc.vpc_id


  tags = merge(
    var.default_tags,
    {
      Name = "${var.project_name}-alb-sg"
    },
  )


}

resource "aws_vpc_security_group_ingress_rule" "sg_alb_443" {
  security_group_id = aws_security_group.sg_alb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.sg_alb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}



resource "aws_security_group" "sg_task" {
  name        = "${var.project_name}-task-sg"
  description = "Allow Traffic"
  vpc_id      = module.vpc.vpc_id


  tags = merge(
    var.default_tags,
    {
      Name = "${var.project_name}-alb-sg"
    },
  )

}


resource "aws_security_group_rule" "sg_task_80" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sg_task.id
  source_security_group_id = aws_security_group.sg_alb.id
}


resource "aws_vpc_security_group_egress_rule" "allow_all_task_traffic_ipv4" {
  security_group_id = aws_security_group.sg_task.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
