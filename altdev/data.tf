data "aws_availability_zones" "azs" {}

data "external" "public_ips" {
program = ["bash", "-c", "aws ec2 describe-instances --query 'Reservations[*].Instances[*].[PublicIpAddress]' --output json | jq -r 'to_entries | map(\"Instance-(.key)=(.value|@sh)\") | .[]' > host-inventory"]
}

data "aws_iam_role" "iam_role" {
  name = "AWSServiceRoleForElasticLoadBalancing"
}