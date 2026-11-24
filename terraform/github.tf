# IAM user the deploy workflow authenticates as, with a static access key stored
# in the repo's Actions secrets. The secret key lands in Terraform state (the
# state bucket is private and encrypted); rotate with
#   terraform apply -replace=aws_iam_access_key.deploy
# and re-set the two secrets.
resource "aws_iam_user" "deploy" {
  name = "${var.name_prefix}-github-deploy"

  tags = {
    Component = "security"
  }
}

resource "aws_iam_access_key" "deploy" {
  user = aws_iam_user.deploy.name
}

data "aws_iam_policy_document" "deploy" {
  statement {
    sid       = "ListSiteBucket"
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.site.arn]
  }

  statement {
    sid       = "WriteSiteObjects"
    actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = ["${aws_s3_bucket.site.arn}/*"]
  }

  statement {
    sid       = "InvalidateCdn"
    actions   = ["cloudfront:CreateInvalidation", "cloudfront:GetInvalidation"]
    resources = [aws_cloudfront_distribution.site.arn]
  }
}

resource "aws_iam_user_policy" "deploy" {
  name   = "deploy-site"
  user   = aws_iam_user.deploy.name
  policy = data.aws_iam_policy_document.deploy.json
}
