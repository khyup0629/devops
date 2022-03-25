data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

locals {
  common_tags = {
    "Project" = "hyeob-ansible"
  }
}


resource "aws_instance" "ubuntu" {
  count = 2

  ami           = data.aws_ami.ubuntu.image_id
  instance_type = "t2.micro"
  subnet_id     = local.subnet_groups["public"].ids[0]
  key_name      = "hyeob-home-keypair"

  associate_public_ip_address = true
  vpc_security_group_ids = [
    module.sg__ssh.id,
  ]

  tags = merge(
    local.common_tags,
    {
      Name = "${local.vpc.name}-ubuntu"
    }
  )
}
