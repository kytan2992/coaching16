locals {
  resource_prefix = "ky-tf"
}

output "web_acl_arn" {
  value = aws_wafv2_web_acl.api.arn
}