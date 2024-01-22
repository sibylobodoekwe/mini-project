provider "aws" {
  region = "eu-west-1"
}
# Create a security group for the EC2 instances
resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Allow HTTP traffic"
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

# Create 3 EC2 instances
# resource "aws_instance" "ec2_instances" {
#   count = 3

#   ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI
#   instance_type = "t2.micro"
#   key_name      = "altdevssh"
#   subnet_id     = aws_subnet.public.id
#   vpc_security_group_ids = [aws_security_group.ec2_sg.id]

#   user_data = <<-EOF
#               #!/bin/bash
#               sudo yum update -y
#               sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
#               sudo yum install -y httpd
#               sudo systemctl start httpd
#               sudo systemctl enable httpd
#               EOF

#   tags = {
#     Name = "ec2-instance-${count.index}"
#   }
# }

# Create a security group for the Elastic Load Balancer
resource "aws_security_group" "elb_sg" {
  name        = "elb_sg"
  description = "Allow HTTP traffic"
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

# Create an Elastic Load Balancer
resource "aws_elb" "elb" {
  name            = "elb"
  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.elb_sg.id]

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
}

# Create a custom Route53 domain
resource "aws_route53_zone" "main" {
  name = "ssibdev.com.ng"

  tags = {
    Environment = "production"
  }
}

# Create an Ansible script to install Apache and display a simple HTML page
resource "local_file" "ansible_playbook" {
  content  = <<-EOF
    ---
    - hosts: ec2_instances
      become: yes
      tasks:
        - name: Install Apache
          yum:
            name: httpd
            state: present

        - name: Set timezone to Africa/Lagos
          command: timedatectl set-timezone Africa/Lagos

        - name: Create a simple HTML page
          blockinfile:
            path: /var/www/html/index.html
            create: yes
            block: |
              <html>
                <body>
                  <h1>Hello from Terraform and Ansible!</h1>
                  <p>This is instance {{ inventory_hostname }}</p>
                </body>
              </html>

        - name: Restart Apache
          service:
            name: httpd
            state: restarted
          EOF
  filename = "ansible-playbook.yml"
}