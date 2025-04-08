resource "aws_dynamodb_table" "url_table" {
  name         = "${local.resource_prefix}-urls"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "short_id"

  attribute {
    name = "short_id"
    type = "S"
  }

  attribute {
    name = "long_url"
    type = "S"
  }

  ttl {
    attribute_name = "ttl"
    enabled        = true
  }

  point_in_time_recovery {
    enabled = true
  }

}

  