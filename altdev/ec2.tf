
resource "aws_instance" "ec2_instances" {
  count                  = 3
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  key_name               = "altdevssh"
  subnet_id              = element(aws_subnet.private.*.id, count.index)
  vpc_security_group_ids = [aws_security_group.sg.id]

  # user_data = <<-EOF
  #             #!/bin/bash
  #             sudo yum update -y
  #             sudo yum install -y httpd
  #             sudo systemctl start httpd
  #             sudo systemctl enable httpd
  #             EOF

  tags = {
    Name = "ec2-instance-${count.index}"
  }
}

resource "aws_security_group" "sg" {
  name        = "ec2-sg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_subnet" "private" {
  count             = 3
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index + 1)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.main.id

  tags = {
    Name = "private-subnet-${count.index}"
  }
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "public" {
  count = length(var.subnet_cidrs)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.subnet_cidrs, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet ${count.index + 1}"
  }
}