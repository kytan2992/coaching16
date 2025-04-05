data "archive_file" "create_url" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_functions/create_url"
  output_path = "${path.module}/lambda_functions/create_url.zip"  
}

data "archive_file" "retrieve_url" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_functions/retrieve_url"
  output_path = "${path.module}/lambda_functions/retrieve_url.zip"  
}

resource "aws_lambda_function" "create_url" {
  function_name = "${local.resource_prefix}-create-url"
  handler       = "create_url.lambda_handler"
  runtime       = "python3.13"
  role          = aws_iam_role.lambda_role.arn
  filename      = "${path.module}/lambda_functions/create_url.zip"

  source_code_hash = data.archive_file.create_url.output_base64sha256

  tracing_config {
    mode = "Active"
  }

  environment {
    variables = {
      DB_NAME        = aws_dynamodb_table.url_table.name
      REGION_AWS     = "us-east-1"
      MIN_CHAR       = 12
      MAX_CHAR       = 16
    }
  }
}

resource "aws_lambda_function" "retrieve_url" {
  function_name = "${local.resource_prefix}-retrieve-url"
  handler       = "retrieve_url.lambda_handler"
  runtime       = "python3.13"
  role          = aws_iam_role.lambda_role.arn
  filename      = "${path.module}/lambda_functions/retrieve_url.zip"

  source_code_hash = data.archive_file.retrieve_url.output_base64sha256

  tracing_config {
    mode = "Active"
  }

  environment {
    variables = {
      DB_NAME        = aws_dynamodb_table.url_table.name
      REGION_AWS     = "us-east-1"
    }
  }
}

resource "aws_cloudwatch_log_group" "create_url_logs" {
  name              = "/aws/lambda/${aws_lambda_function.create_url.function_name}"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "retrieve_url_logs" {
  name              = "/aws/lambda/${aws_lambda_function.retrieve_url.function_name}"
  retention_in_days = 7
}

