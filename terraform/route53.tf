resource "aws_route53_record" "api" {
  zone_id = data.aws_route53_zone.sctp_zone.zone_id
  name    = "${local.resource_prefix}-urlshortener.sctp-sandbox.com"
  type    = "A"

  alias {
    name                   = aws_api_gateway_domain_name.shortener.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.shortener.regional_zone_id
    evaluate_target_health = true
  }
}

resource "aws_acm_certificate" "cert" {
  domain_name       = "${local.resource_prefix}-urlshortener.sctp-sandbox.com"
  validation_method = "DNS" # You can also use "EMAIL" but DNS is preferred
  key_algorithm     = "RSA_2048"

  tags = {
    Name = "${local.resource_prefix}-urlshortener.sctp-sandbox.com-certificate"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_domain_name" "shortener" {
  domain_name              = "${local.resource_prefix}-urlshortener.sctp-sandbox.com"
  regional_certificate_arn = aws_acm_certificate.cert.arn

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}
