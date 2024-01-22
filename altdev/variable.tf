variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "domain_name" {
  type    = string
  default = "ssibdev.com.ng"
}

variable "subdomain_name" {
  type    = string
  default = "terraform-test"
}

variable "subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"] # Update with your desired CIDR blocks
}

variable "availability_zones" {
  type    = list(string)
  default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"] # Update with your desired availability zones
}
