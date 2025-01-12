##########################
# Route53 Host Zone
##########################
data "aws_route53_zone" "host_domain" {
    name = local.host_domain
}

resource "aws_route53_zone" "app_subdomain" {
    name = local.app_domain_name
    tags = {
        Name = "${local.app_name}-app-subdomain"
    }
}

resource "aws_route53_zone" "api_subdomain" {
    name = local.api_domain_name
    tags = {
        Name = "${local.app_name}-api-subdomain"
    }
}

##########################
# NS record
##########################
resource "aws_route53_record" "ns_record_for_app_subdomain" {
    name = aws_route53_zone.app_subdomain.name
    type = "NS"
    zone_id = data.aws_route53_zone.host_domain.zone_id
    records = [
        aws_route53_zone.app_subdomain.name_servers[0],
        aws_route53_zone.app_subdomain.name_servers[1],
        aws_route53_zone.app_subdomain.name_servers[2],
        aws_route53_zone.app_subdomain.name_servers[3],
    ]
    ttl = 172800
}

resource "aws_route53_record" "ns_record_for_api_subdomain" {
    name = aws_route53_zone.api_subdomain.name
    type = "NS"
    zone_id = data.aws_route53_zone.host_domain.zone_id
    records = [
        aws_route53_zone.api_subdomain.name_servers[0],
        aws_route53_zone.api_subdomain.name_servers[1],
        aws_route53_zone.api_subdomain.name_servers[2],
        aws_route53_zone.api_subdomain.name_servers[3],
    ]
    ttl = 172800
}
