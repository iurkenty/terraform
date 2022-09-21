provider "aws" {
  region = var.aws_region
}

resource "aws_kms_key" "s3_key" {
  description = "KMS key used to encrypt objects"
  deletion_window_in_days = 10
}

//noinspection HCLDeprecatedElement
resource "aws_s3_bucket" "gogreen-utility-bucket-iurkenty" {
  bucket = var.bucket_name
  acl = "private"
  force_destroy = true

  //noinspection HCLDeprecatedElement
  server_side_encryption_configuration  {
    rule  {
    apply_server_side_encryption_by_default  {
            kms_master_key_id = aws_kms_key.s3_key.arn
            sse_algorithm     = "aws:kms"
    }
  }
  }

  //noinspection HCLDeprecatedElement
  lifecycle_rule  {
    id      = "log"
    enabled = true

    prefix  = "log/"

    transition  {
        days          = 90
        storage_class = "GLACIER"
      }

    expiration  {
      days = 1825
    }
  }
}