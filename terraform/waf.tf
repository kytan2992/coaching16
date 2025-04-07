resource "aws_wafv2_web_acl" "api" {
  name        = "${local.resource_prefix}-urlshortener-web-acl"
  description = "WAF for API Gateway to allow only specific IPs"
  scope       = "REGIONAL"

  default_action {
    block {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${local.resource_prefix}-urlshortener-metrics"
    sampled_requests_enabled   = true
  }

  rule {
    name     = "allow-only-my-ip"
    priority = 1

    action {
      allow {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.allow_ip.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${local.resource_prefix}-urlshortener-allow-ip"
      sampled_requests_enabled   = true
    }
  }  
}

resource "aws_wafv2_ip_set" "allow_ip" {
  name               = "${local.resource_prefix}-urlshortener-allowed-ip"
  description        = "Allowed IP addresses"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"

  addresses = ["119.56.103.169/32"] # Replace with your allowed IP address
}

resource "aws_wafv2_web_acl_association" "api" {
  resource_arn = aws_api_gateway_stage.rest_api.arn
  web_acl_arn  = aws_wafv2_web_acl.api.arn
}

resource "aws_cloudwatch_log_group" "waf_logs" {
  name              = "/aws/waf/${local.resource_prefix}-urlshortener-web-acl"
  retention_in_days = 7
}

resource "aws_wafv2_web_acl_logging_configuration" "api_gw_waf_logging" {
  resource_arn = aws_wafv2_web_acl.api.arn
  log_destination_configs = [
    aws_cloudwatch_log_group.waf_logs.arn
  ]

  logging_filter {
    # Default behavior when no filters match
    default_behavior = "DROP" # means "do not log" if no filter matches

    filter {
      behavior    = "KEEP" # keep logs if the condition matches
      requirement = "MEETS_ANY"

      condition {
        action_condition {
          action = "BLOCK"
        }
      }
    }
  }
}