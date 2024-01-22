resource "aws_elb" "main" {
  name            = "ec2-elb"
  subnets         = aws_subnet.private.*.id
  security_groups = [aws_security_group.sg.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "HTTP:80/"
  }
  instances = aws_instance.ec2_instances.*.id

  tags = {
    Name = "ec2-elb"
  }
}