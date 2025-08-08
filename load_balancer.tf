resource "aws_alb" "main" {
  count              = var.habilitar_loadbalancer ? 1 : 0
  name               = "${var.project_name}-loadbalancer"
  internal           = var.internal_alb
  load_balancer_type = "application"
  security_groups    = [aws_security_group.loadbalancer[0].id]
  subnets            = aws_subnet.public[*].id
  enable_zonal_shift = true

  tags = {
    Name = "${var.project_name}-Loadbalancer"
  }
}

resource "aws_alb_listener" "listiner_443" {
  count             = var.habilitar_loadbalancer ? 1 : 0
  load_balancer_arn = aws_alb.main[0].arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = var.loadbalancer_ssl_policy
  certificate_arn   = var.certificado_listiner_443
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = "200"
      message_body = "Você chegou ao ALB ${var.project_name}"
    }
  }
}

resource "aws_alb_listener" "listiner_80" {
  count             = var.habilitar_loadbalancer ? 1 : 0
  load_balancer_arn = aws_alb.main[0].arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_security_group" "loadbalancer" {
  count  = var.habilitar_loadbalancer ? 1 : 0
  name   = "${var.project_name}-loadbalancer-sg"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-loadbalancer-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_443" {
  count             = var.habilitar_loadbalancer ? 1 : 0
  security_group_id = aws_security_group.loadbalancer[0].id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_80" {
  count             = var.habilitar_loadbalancer ? 1 : 0
  security_group_id = aws_security_group.loadbalancer[0].id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv6_443" {
  count             = var.habilitar_loadbalancer ? 1 : 0
  security_group_id = aws_security_group.loadbalancer[0].id
  cidr_ipv6         = "::/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv6_80" {
  count             = var.habilitar_loadbalancer ? 1 : 0
  security_group_id = aws_security_group.loadbalancer[0].id
  cidr_ipv6         = "::/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  count             = var.habilitar_loadbalancer ? 1 : 0
  security_group_id = aws_security_group.loadbalancer[0].id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  count             = var.habilitar_loadbalancer ? 1 : 0
  security_group_id = aws_security_group.loadbalancer[0].id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1"
}