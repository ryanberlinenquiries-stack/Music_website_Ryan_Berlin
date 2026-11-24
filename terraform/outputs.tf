output "bucket_name" {
  description = "Set as the AWS_S3_BUCKET repo variable."
  value       = aws_s3_bucket.site.bucket
}

output "cloudfront_distribution_id" {
  description = "Set as the AWS_CLOUDFRONT_DISTRIBUTION_ID repo variable."
  value       = aws_cloudfront_distribution.site.id
}

output "deploy_access_key_id" {
  description = "Set as the AWS_ACCESS_KEY_ID repo secret."
  value       = aws_iam_access_key.deploy.id
}

output "deploy_secret_access_key" {
  description = "Set as the AWS_SECRET_ACCESS_KEY repo secret."
  value       = aws_iam_access_key.deploy.secret
  sensitive   = true
}

output "site_url" {
  value = "https://${aws_cloudfront_distribution.site.domain_name}"
}
