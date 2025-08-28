provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

# S3 Bucket for raw data
resource "aws_s3_bucket" "otee_raw" {
  bucket = "otee-raw-${var.env}-${var.account_id}"

  tags = {
    Name        = "Otee Raw Data Bucket"
    Environment = var.env
  }
}

# S3 Bucket Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "otee_raw_sse" {
  bucket = aws_s3_bucket.otee_raw.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.otee_sse.arn
    }
  }
}

# S3 Public Access Block
resource "aws_s3_bucket_public_access_block" "otee_block" {
  bucket                  = aws_s3_bucket.otee_raw.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# KMS Key for encryption
resource "aws_kms_key" "otee_sse" {
  description             = "CMK for Otee ingestion data"
  deletion_window_in_days = 30
  enable_key_rotation     = true
}

# DynamoDB Table for indexing
resource "aws_dynamodb_table" "otee_index" {
  name         = "otee-index-table-${var.env}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "deviceId"
  range_key    = "ts"

  attribute {
    name = "deviceId"
    type = "S"
  }

  attribute {
    name = "ts"
    type = "S"
  }

  tags = {
    Name        = "Otee Index Table"
    Environment = var.env
  }
}

# SNS Topic for alerts
resource "aws_sns_topic" "otee_alerts" {
  name = "otee-alerts-topic-${var.env}"

  tags = {
    Name        = "Otee Alerts Topic"
    Environment = var.env
  }
}

# Kinesis Stream for ingestion
resource "aws_kinesis_stream" "otee_ingest" {
  name        = "otee-ingest-stream-${var.env}"
  shard_count = 1

  tags = {
    Name        = "Otee Ingest Stream"
    Environment = var.env
  }
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_exec" {
  name = "lambda-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policy for Lambda
resource "aws_iam_policy" "lambda_policy" {
  name = "lambda-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject"
        ],
        Effect   = "Allow",
        Resource = "${aws_s3_bucket.otee_raw.arn}/*"
      },
      {
        Action = [
          "dynamodb:PutItem"
        ],
        Effect   = "Allow",
        Resource = aws_dynamodb_table.otee_index.arn
      },
      {
        Action = [
          "sns:Publish"
        ],
        Effect   = "Allow",
        Resource = aws_sns_topic.otee_alerts.arn
      }
    ]
  })
}

# Attach IAM Policy to Role
resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}