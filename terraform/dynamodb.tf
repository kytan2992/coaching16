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

  attribute {
    name = "created_at"
    type = "S"
  }

  attribute {
    name = "ttl"
    type = "N"
  }

  attribute {
    name = "short_url"
    type = "S"
  }

  attribute {
    name = "hits"
    type = "N"
  }

  attribute {
    name = "analytics"
    type = "M"  # Map type for nested data (User-Agent, source IP, etc.)
  }
  
  ttl {
    attribute_name = "ttl"
    enabled        = true  # Enable TTL functionality for automatic deletion
  }
}
