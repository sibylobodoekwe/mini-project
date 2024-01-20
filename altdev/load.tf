resource "aws_lb_target_group" "tg" {
  name        = "TargetGroup"
  port        = 80
  target_type = "instance"
  protocol    = "HTTP"
  vpc_id      = aws_vpc.custom_vpc.id
}

resource "aws_lb_target_group_attachment" "tgattachment" {
  count            = length(aws_instance.instance.*.id)
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = element(aws_instance.instance.*.id, count.index)
}

resource "aws_lb" "lb" {
  name               = "ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg.id]
  subnets            = aws_subnet.public_subnet.*.id
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      status_code  = "200"
      message_body = "OK"
    }
  }
}

resource "aws_route53_zone" "ec2" {
  name = "ssibdev.com.ng"
}

resource "aws_route53_record" "example" {
  zone_id = aws_route53_zone.ec2.zone_id
  name    = "terraform-test"
  type    = "A"
  ttl     = "300"
  records = [aws_lb.lb.dns_name]
}



