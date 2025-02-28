output "s3_id" {
  value = aws_s3_bucket.base-bucket.id
}

output "s3_arn" {
  value = aws_s3_bucket.base-bucket.arn
}

output "s3_region" {
  value = aws_s3_bucket.base-bucket.region
}

output "s3_website" {
  value = aws_s3_bucket_website_configuration.base-website.website_endpoint
}

output "s3_object" {
  value = { for k, v in aws_s3_object.html_files : k => v.etag }
}

output "s3_object_check" {
  value = { for k, v in aws_s3_object.html_files : k => v.checksum_crc32 }

  depends_on = [ aws_s3_bucket.base-bucket ]

  }