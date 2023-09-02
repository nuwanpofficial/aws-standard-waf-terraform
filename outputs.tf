output "wafv2_id" {
  description = "AWS WAFv2 ID"
  value       = aws_wafv2_web_acl.ext_wafv2.id
}

output "wafv2_arn" {
  description = "AWS WAFv2 ARN"
  value       = aws_wafv2_web_acl.ext_wafv2.arn
}

output "wafv2_logging_s3_name" {
  description = "AWS WAFv2 Logging Bucket"
  value       = aws_s3_bucket.waf_logging_bucket.id
}