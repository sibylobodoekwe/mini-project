resource "aws_route53_record" "a_record" {
  zone_id = data.aws_route53_zone.selected.id
  name    = "${var.subdomain_name}.${var.domain_name}"
  type    = "A"
  alias {
    name                   = aws_elb.main.dns_name
    zone_id                = aws_elb.main.zone_id
    evaluate_target_health = true
  }
}