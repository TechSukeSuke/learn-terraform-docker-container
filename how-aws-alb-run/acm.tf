# ---------------------------------------------
# Certificate
# ---------------------------------------------
data "aws_acm_certificate" "host_domain_wc_acm" {
  domain = local.host_domain
}
