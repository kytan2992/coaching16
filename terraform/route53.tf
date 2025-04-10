module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name       = "${local.resource_prefix}-urlshortener.sctp-sandbox.com"
  zone_id           = data.aws_route53_zone.sctp_zone.zone_id
  validation_method = "DNS"
}
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

resource "aws_api_gateway_domain_name" "shortener" {
  domain_name              = "${local.resource_prefix}-urlshortener.sctp-sandbox.com"
  regional_certificate_arn = module.acm.acm_certificate_arn

  endpoint_configuration {
    types = ["REGIONAL"]
  }

}
