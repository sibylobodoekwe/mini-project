
variable "ami_id" {
  description = "AMI ID for instances"
  type        = string
  default     = "ami-062a49a8152e4c031"
}
variable "custom_vpc" {
  description = "VPC for testing environment"
  type        = string
  default     = "10.0.0.0/16"
}

variable "instance_tenancy" {
  description = "it defines the tenancy of VPC. Whether it's default or dedicated"
  type        = string
  default     = "default"
}

variable "instance_type" {
  description = "Instance type to create an instance"
  type        = string
  default     = "t2.micro"
}

variable "aws_key_pair" {
  description = "PEM file of Keypair used to login to EC2 instances"
  type        = string
  default     = "altdev.pem" 
}

variable "availability_zones" {
  description   = "availability zone of the instance"
  type          =  string
  # default       = map(any)
}
variable "instance_count" {
 description = "Number of instances to create"
 type        = number
 default     = 3
}

variable "iam_instance_profile_name" {
  description = "IAM instance profile name"
  type        = string
  default     = "default"  
}

variable "public_key_path" {
  description = "Path to the public key file"
  type        = string
  default     = "altdev.pub"
}
