# Using Hashicorp module to help upload files to s3 bucket 
module "template_files" {
    source = "hashicorp/dir/template"
    base_dir = "${path.module}/web-content"
}

# Creates a bucket
resource "aws_s3_bucket" "mys3" {
  bucket = "${var.env}.femiodedina"
  force_destroy = true
  
  tags = {
    Name = "${var.env}.femiodedina"
  }
}

#Uploads files to s3bucket
resource "aws_s3_object" "Bucket_files" {
  bucket =  aws_s3_bucket.mys3.id
  for_each = module.template_files.files
  key = each.key
  content_type = each.value.content_type
  source  = each.value.source_path
  content = each.value.content
}

#Enables static website from s3
resource "aws_s3_bucket_website_configuration" "s3web" {
  bucket = aws_s3_bucket.mys3.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}


# Now the fun part cloudfront

#Getting cert
data "aws_acm_certificate" "myacm" {
  domain = "*.odedina.icu"
  statuses = ["ISSUED"]
}


#Getting domain name
data "aws_route53_zone" "hosted_zone" {
  zone_id = var.hosted_zoneid
}

#creating Record
resource "aws_route53_record" "record" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name = "${var.env}.odedina.icu"
  type = "A"

  alias {
    name = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}

#policy for s3 to communicate with cloudfront
data "aws_iam_policy_document" "origin_bucket_policy" {
  statement {
    sid    = "AllowCloudFrontServicePrincipalReadWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.mys3.arn}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.s3_distribution.arn]
    }
  }
}


resource "aws_s3_bucket_policy" "mybucket_policy" {
  bucket = aws_s3_bucket.mys3.bucket
  policy = data.aws_iam_policy_document.origin_bucket_policy.json
}

#OAC
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "s3-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

#The actual cloudfront distribution
resource "aws_cloudfront_distribution" "s3_distribution" {
  enabled = true
  is_ipv6_enabled = false
  default_root_object = "index.html"
  aliases = [ "${var.env}.odedina.icu" ]
  price_class = "PriceClass_200"
  
  
  
  origin {
    domain_name = aws_s3_bucket.mys3.bucket_domain_name
    origin_id = aws_s3_bucket.mys3.bucket
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.mys3.bucket
    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "redirect-to-https"
  }

  viewer_certificate {
    acm_certificate_arn = data.aws_acm_certificate.myacm.arn
    ssl_support_method = "sni-only"
  }
}