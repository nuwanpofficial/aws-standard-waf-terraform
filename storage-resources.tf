resource "aws_s3_bucket" "waf_logging_bucket" {
  bucket = join("-", ["aws-waf-logs", var.environment, var.application, "s3", var.rg_short])

}

resource "aws_s3_bucket_public_access_block" "s3_publc_block" {
  bucket = aws_s3_bucket.waf_logging_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "s3_allow_putlogs" {
  bucket = aws_s3_bucket.waf_logging_bucket.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "AWSLogDeliveryWrite",
    "Statement" : [
      {
        "Sid" : "AllowSSLRequestsOnly",
        "Action" : "s3:*",
        "Effect" : "Deny",
        "Resource" : [
          "${aws_s3_bucket.waf_logging_bucket.arn}",
          "${aws_s3_bucket.waf_logging_bucket.arn}/*"
        ],
        "Condition" : {
          "Bool" : {
            "aws:SecureTransport" : "false"
          }
        },
        "Principal" : "*"
      },
      {
        "Sid" : "AWSLogDeliveryWrite",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "delivery.logs.amazonaws.com"
        },
        "Action" : "s3:PutObject",
        "Resource" : "${aws_s3_bucket.waf_logging_bucket.arn}/*",
        "Condition" : {
          "StringEquals" : {
            "s3:x-amz-acl" : "bucket-owner-full-control",
            "aws:SourceAccount" : "${data.aws_caller_identity.current.account_id}"
          },
          "ArnLike" : {
            "aws:SourceArn" : "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:*"
          }
        }
      },
      {
        "Sid" : "AWSLogDeliveryAclCheck",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "delivery.logs.amazonaws.com"
        },
        "Action" : "s3:GetBucketAcl",
        "Resource" : "${aws_s3_bucket.waf_logging_bucket.arn}",
        "Condition" : {
          "StringEquals" : {
            "aws:SourceAccount" : "${data.aws_caller_identity.current.account_id}"
          },
          "ArnLike" : {
            "aws:SourceArn" : "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:*"
          }
        }
      },
      {
        "Sid" : "BucketLocation",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "delivery.logs.amazonaws.com"
        },
        "Action" : "s3:GetBucketLocation",
        "Resource" : "${aws_s3_bucket.waf_logging_bucket.arn}",
        "Condition" : {
          "StringEquals" : {
            "aws:SourceAccount" : "${data.aws_caller_identity.current.account_id}"
          },
          "ArnLike" : {
            "aws:SourceArn" : "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:*"
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_lifecycle_configuration" "waf_s3_lifecycle" {
  bucket = aws_s3_bucket.waf_logging_bucket.id

  rule {
    id     = "Delete-Objects-${var.s3_data_retentions_days}-Days"
    status = "Enabled"
    filter {}
    expiration {
      days                         = var.s3_data_retentions_days
      expired_object_delete_marker = true
    }
  }
}