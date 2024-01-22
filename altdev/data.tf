
data "aws_iam_role" "iam_role" {
  name = "awsec2admin"
}

data "aws_route53_zone" "selected" {
  name         = var.domain_name
  private_zone = false
  vpc_id       = aws_vpc.main.id

}


data "aws_elb_service_account" "main" {}

data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

data "aws_availability_zones" "available" {}

data "aws_route53_zone" "main" {
  name         = var.domain_name
  private_zone = false
  vpc_id       = aws_vpc.main.id
}
