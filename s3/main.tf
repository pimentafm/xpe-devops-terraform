terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.62.0"
    }
  }
}

provider "aws" {
  profile = "sciagri"
  region  = "us-east-1"
}

resource "aws_s3_bucket" "datalake" {
  bucket = "${var.bucket_name}-${var.environment}"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name        = "${var.bucket_name}-${var.environment}"
    Environment = "${var.environment}"
  }
}

resource "aws_s3_bucket_object" "update_spark_code" {
  bucket = aws_s3_bucket.datalake.id
  key    = "emr-code/pyspark/spark_job.py"
  acl    = "private"
  source = "../spark_job.py"
  etag   = filemd5("../spark_job.py")
}
