
output "elb_dns_name" {
  value = aws_elb.main.dns_name
}

output "hosted_zone_id" {
  value = aws_route53_zone.main.zone_id
}

output "host_inventory" {
  value = <<-EOF
    [ec2_instances]
    ${join("\n", aws_instance.ec2_instances.*.public_ip)}
    EOF
}