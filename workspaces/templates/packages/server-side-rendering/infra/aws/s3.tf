# S3 Buckets for file hosting

# Creates bucket to store the static website
resource "aws_s3_bucket" "static_files" {
  bucket = "${var.domain}-static-files"

  acl = "public-read"

  # Remove this line if you want to prevent accidential deletion of bucket
  force_destroy = true

  tags = {
    ManagedBy = "terraform"
    Changed   = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
  }

  policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "PublicReadForGetBucketObjects",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${var.domain}-static-files/*"
    }
  ]
}
EOF

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_s3_bucket_website_configuration" "static_files_web" {
  bucket = aws_s3_bucket.static_files.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html"
  }

}

resource "aws_s3_bucket" "public_files" {
  bucket = "${var.domain}-public-files"

  acl = "public-read"

  # Remove this line if you want to prevent accidential deletion of bucket
  force_destroy = true

  tags = {
    ManagedBy = "terraform"
    Changed   = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
  }

  policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "PublicReadForGetBucketObjects",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${var.domain}-public-files/*"
    }
  ]
}
EOF

  lifecycle {
    ignore_changes = [tags]
  }
}


resource "aws_s3_bucket_website_configuration" "public_files_web" {
  bucket = aws_s3_bucket.public_files.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html"
  }

}