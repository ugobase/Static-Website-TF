resource "random_id" "s3bucket-suffix" {
  byte_length = 6
}

resource "aws_s3_bucket" "base-bucket" {
  bucket = "ugobase-bucket-${random_id.s3bucket-suffix.hex}"

  tags = local.common_tags

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_s3_bucket_policy" "base-policy" {
  bucket = aws_s3_bucket.base-bucket.id
  
  policy = templatefile("policy.tpl", {
    bucket_arn = aws_s3_bucket.base-bucket.arn
  })


}

resource "aws_s3_bucket_public_access_block" "base-public-access" {
  bucket = aws_s3_bucket.base-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false


}

resource "aws_s3_bucket_website_configuration" "base-website" {
  bucket = aws_s3_bucket.base-bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

}

resource "aws_s3_object" "html_files" {
  for_each = toset(["error.html", "index.html"])  # Create both error.html and index.html

  bucket      = aws_s3_bucket.base-bucket.id
  key         = each.value    # Use each value (either error.html or index.html)
  source      = "./${each.value}"  # Dynamically reference the file path
  etag        = filemd5("./${each.value}")
  content_type = "text/html"

  tags = merge(local.common_tags, {
    Document = "Html Files"
  })

  lifecycle {
    create_before_destroy = true
  }
}



