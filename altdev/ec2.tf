resource "aws_instance" "instance" {
  count             = var.instance_count
  ami               = var.ami_id
  instance_type     = var.instance_type
  subnet_id         = element(aws_subnet.public_subnet.*.id, count.index)
  security_groups   = [aws_security_group.sg.id]
  key_name        = aws_key_pair.key_name.key_name
  iam_instance_profile = aws_iam_instance_profile.example.name

  tags = {
    "Name"        = "Instance-${count.index}"
    "Environment" = "Test"
    "CreatedBy"   = "Terraform"
}

  timeouts {
    create = "10m"
  }

}
resource "aws_key_pair" "key_name" {
  key_name   = "key_name"
  public_key = file("./altdev.pub")
}

resource "aws_iam_instance_profile" "example" {
  name = "example-profile"
}

resource "null_resource" "null" {
  count = length(aws_subnet.public_subnet.*.id)

  provisioner "file" {
    source      = "./userdata.sh"
    destination = "/home/ec2-user/userdata.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ec2-user/userdata.sh",
      "sh /home/ec2-user/userdata.sh",
    ]
    on_failure = continue
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    port        = "22"
    host        = element(aws_eip.eip.*.public_ip, count.index)
    private_key = file(var.aws_key_pair)
  }

}

resource "aws_eip" "eip" {
  count            = length(aws_instance.instance.*.id)
  instance         = element(aws_instance.instance.*.id, count.index)
  public_ipv4_pool = "amazon"

  tags = {
    "Name" = "EIP-${count.index}"
  }
}


