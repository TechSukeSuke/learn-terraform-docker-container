####################################################
# ALB Security Group
####################################################
resource "aws_security_group" "main" {
    name = "${local.app_name}-alb-sg"
    vpc_id = aws_vpc.main.id

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${local.app_name}-alb-sg"
    }
}

resource "aws_security_group_rule" "alb_http" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_group_id = aws_security_group.main.id
    cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_https" {
    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    security_group_id = aws_security_group.main.id
    cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_ssh" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_group_id = aws_security_group.main.id
    cidr_blocks = ["0.0.0.0/0"]
}

####################################################
# ALB
####################################################
resource "aws_lb" "main" {
    name = "${local.app_name}-alb"
    load_balancer_type = "application"
    subnets = [
        aws_subnet.public-1a.id,
        aws_subnet.public-1c.id,
    ]
    security_groups = [aws_security_group.main.id]
}

resource "aws_lb_listener" "main" {
    load_balancer_arn = aws_lb.main.arn
    port = 80
    protocol = "HTTP"
    default_action {
        type = "redirect"
        redirect {
            port = "443"
            protocol = "HTTPS"
            status_code = "HTTP_301"
        }
    }
}

resource "aws_lb_listener" "https" {
    load_balancer_arn = aws_lb.main.arn
    port = 443
    protocol = "HTTPS"
    certificate_arn = data.aws_acm_certificate.host_domain_wc_acm.arn
    default_action {
        type = "fixed-response"
        fixed_response {
            content_type = "text/plain"
            message_body = "503 Service Temporarily Unavailable"
            status_code = "503"
        }
    }
}

####################################################
# Route53 record for ALB
####################################################
resource "aws_route53_record" "a_record_for_app_subdomain" {
    name = aws_route53_zone.app_subdomain.name
    type = "A"
    zone_id = aws_route53_zone.app_subdomain.zone_id
    alias {
        evaluate_target_health = true
        name = aws_lb.main.dns_name
        zone_id = aws_lb.main.zone_id
    }
}

resource "aws_route53_record" "a_record_for_api_subdomain" {
    name = aws_route53_zone.api_subdomain.name
    type = "A"
    zone_id = aws_route53_zone.api_subdomain.zone_id
    alias {
        evaluate_target_health = true
        name = aws_lb.main.dns_name
        zone_id = aws_lb.main.zone_id
    }
}
