resource "aws_dynamodb_table" "url_table" {
  name         = "${local.resource_prefix}-urls"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "short_id"

   attribute {
    name = "short_id"
    type = "S"
  }

}
  
  