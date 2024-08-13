resource "aws_acm_certificate" "expense" {
  domain_name       = "*.harshadevops.site"
  validation_method = "DNS"
  tags              = {}
}

resource "aws_route53_record" "expense" {
  for_each = {
    for dvo in aws_acm_certificate.expense.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 1
  type            = each.value.type
  zone_id         = data.aws_route53_zone.this.id
}

resource "aws_acm_certificate_validation" "example" {
  certificate_arn         = aws_acm_certificate.expense.arn
  validation_record_fqdns = [for record in aws_route53_record.expense : record.fqdn]
}
