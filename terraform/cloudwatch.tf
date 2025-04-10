## CLOUDWATCH ALARM FOR CREATE URL ##

resource "aws_sns_topic" "createurl_alerts" {
  name = "${local.resource_prefix}-createurl-alerts"
}

resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  alarm_name          = "${local.resource_prefix}-createurl-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 60
  statistic           = "Sum"
  threshold           = 1

  dimensions = {
    FunctionName = aws_lambda_function.create_url.function_name
  }

  alarm_description = "Triggered when Lambda function has errors"
  alarm_actions     = [aws_sns_topic.createurl_alerts.arn]
}

## CLOUDWATCH ALARM FOR RETRIEVE URL ##

resource "aws_sns_topic" "retrieveurl_alerts" {
  name = "${local.resource_prefix}-retrieveurl-alerts"
}

resource "aws_cloudwatch_metric_alarm" "retrieveurl_errors" {
  alarm_name          = "${local.resource_prefix}-retrieveurl-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 60
  statistic           = "Sum"
  threshold           = 1

  dimensions = {
    FunctionName = aws_lambda_function.retrieve_url.function_name
  }

  alarm_description = "Triggered when Lambda function has errors"
  alarm_actions     = [aws_sns_topic.retrieveurl_alerts.arn]
}