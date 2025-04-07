data "aws_route53_zone" "sctp_zone" {
  name = "sctp-sandbox.com"
}

data "aws_caller_identity" "current" {}
