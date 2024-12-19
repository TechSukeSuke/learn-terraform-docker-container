# ---------------------------------------------
# Certificate
# ---------------------------------------------
resource "aws_acm_certificate" "host_domain_wc_acm" {
  domain_name       = "*.${local.host_domain}"
  validation_method = "DNS"

  tags = {
    Name    = "${local.app_name}-acm"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_route53_zone.app_subdomain
  ]
}