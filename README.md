# coaching16
Terraform code for creating API Gateway with a Custom Domain (Route53) configured with public ACM Cert, 2 Lambdas (1 for POST /newurl and 1 for GET /{shortid}), DynamoDB to store the short ids, AWS WAF to ensure that the API Gateway is only accessible from your IP, X-ray for tracing, Cloudwatch Alarms + SNS for alerts 
