
resource "aws_s3_bucket" "first_bucket" {
  count = length(var.bucket_names)

  bucket = var.bucket_names[count.index]
  tags   = var.tags
}

resource "aws_s3_bucket" "second_bucket" {
  for_each = toset(var.bucket_names)
  bucket   = each.key
  tags     = var.tags

  depends_on = [ aws_s3_bucket.first_bucket ]
}

