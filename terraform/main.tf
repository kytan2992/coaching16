locals {
  resource_prefix = "ky-tf"
}

output "log_group_arn" {
  value = aws_cloudwatch_log_group.waf_logs.arn
}