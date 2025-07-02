#Grabbing my already created hosted zone from aws
data "aws_route53_zone" "hosted_zone" {
  zone_id = var.hostedzone_id
}


#Creating an A record in the hosted zone to point to alb
resource "aws_route53_record" "A_record" {
  name = "test.odedina.icu"
  type = "A"
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  alias {
    zone_id = aws_alb.lb.zone_id
    name = aws_alb.lb.dns_name
    evaluate_target_health = true
  }
}


#Creating ssl cert
resource "aws_acm_certificate" "cert" {
  domain_name = "test.odedina.icu"
  validation_method = "DNS"
}


#Creating records based on ssl cert
resource "aws_route53_record" "records" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name = dvo.resource_record_name
      record = dvo.resource_record_value
      type = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name = each.value.name
  records = [each.value.record]
  ttl = 60
  type = each.value.type
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
}


#Validating the ssl cert
resource "aws_acm_certificate_validation" "validation" {
  certificate_arn = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.records : record.fqdn]
}