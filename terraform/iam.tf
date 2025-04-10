resource "aws_iam_role" "lambda_role" {
  name               = "${local.resource_prefix}-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role_policy" "lambda_policy" {
  name   = "${local.resource_prefix}-lambda-policy"
  role   = aws_iam_role.lambda_role.id
  policy = data.aws_iam_policy_document.lambda_policy.json
}

resource "aws_lambda_permission" "allow_api_gateway_post" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_url.function_name
  principal     = "apigateway.amazonaws.com"
}

resource "aws_lambda_permission" "allow_api_gateway_get" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.retrieve_url.function_name
  principal     = "apigateway.amazonaws.com"
}