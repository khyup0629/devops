# Terraform Provisioner

- Provisioner : 프로비저너는 특정 서버에서 실행시키면 저장된 명령어를 수행하는 역할을 합니다.

Terraform Provisioner   
- file : 로컬에서 리모트로 파일 복사
- local_exec : 로컬 PC에서 명령어 수행
- remote_exec : 리모트 머신에서 명령어 수행
  - 지원 프로토콜 : SSH(Unix), Win_rm(Windows)
- 첫 리소스 생성 시점에 실행
- 여러 옵션을 통해 삭제 시점, 매번 수행으로 커스터마이징 가능.

AWS EC2 Userdata   
- cloud-init : 부팅 시점에 user_data 부트스트래핑. 사용자 생성, 파일 구성, 소프트웨어 설치. Linux 환경
- AMI를 가지고 첫 부팅 시점에만 실행

```
# main.tf
provider "aws" {
  region = "ap-northeast-2"
}

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
  vpc_name = "default"
  common_tags = {
    "Project" = "provisioner-userdata"
  }
}
resource "aws_default_vpc" "default" {   # default vpc를 사용할 수 있도록 해주는 aws_default_vpc
  tags = {
    Name = local.vpc_name
  }
}

module "security_group" {
  source  = "tedilabs/network/aws//modules/security-group"
  version = "0.24.0"

  name        = "${local.vpc_name}-provisioner-userdata"
  description = "Security Group for test."
  vpc_id      = aws_default_vpc.default.id

  ingress_rules = [
    {
      id          = "ssh"
      protocol    = "tcp"
      from_port   = 22
      to_port     = 22
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow SSH from anywhere."
    },
    {
      id          = "http"
      protocol    = "tcp"
      from_port   = 80
      to_port     = 80
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTP from anywhere."
    },
  ]
  egress_rules = [
    {
      id          = "all/all"
      description = "Allow to communicate to the Internet."
      protocol    = "-1"
      from_port   = 0
      to_port     = 0

      cidr_blocks = ["0.0.0.0/0"]
    },
  ]

  tags = local.common_tags
}


###################################################
# Userdata
###################################################

resource "aws_instance" "userdata" {
  ami           = data.aws_ami.ubuntu.image_id
  instance_type = "t2.micro"
  key_name      = "fastcampus"

  # bash 셀 스크립트 쓰는 방법(유저 데이터가 수정되면, 인스턴스는 교체되기 때문에 주의해서 사용해야 합니다)
  user_data = <<EOT
#!/bin/bash
sudo apt-get update
sudo apt-get install -y nginx
EOT

  vpc_security_group_ids = [
    module.security_group.id,
  ]

  tags = {
    Name = "fastcampus-userdata"
  }
}


###################################################
# Provisioner - in EC2
###################################################

# resource "aws_instance" "provisioner" {
#   ami           = data.aws_ami.ubuntu.image_id
#   instance_type = "t2.micro"
#   key_name      = "fastcampus"
#
#   vpc_security_group_ids = [
#     module.security_group.id,
#   ]
#
#   tags = {
#     Name = "fastcampus-provisioner"
#   }
#
#   provisioner "remote-exec" {
#     inline = [   # 생성 시점에만 실행되기 때문에 안의 내용을 고쳐도 반영되지 않습니다.
#       "sudo apt-get update",
#       "sudo apt-get install -y nginx",
#     ]
#
#     connection {
#       type = "ssh"
#       user = "ubuntu"
#       host = self.public_ip   # 현재 생성한 인스턴스의 퍼블릭 ip로 접근.
#     }
#   }
# }


###################################################
# Provisioner - in null-resources
###################################################

resource "aws_instance" "provisioner" {
  ami           = data.aws_ami.ubuntu.image_id
  instance_type = "t2.micro"
  key_name      = "fastcampus"

  vpc_security_group_ids = [
    module.security_group.id,
  ]

  tags = {
    Name = "fastcampus-provisioner"
  }
}

resource "null_resource" "provisioner" {
  triggers = {
    insteance_id = aws_instance.provisioner.id
    script       = filemd5("${path.module}/files/install-nginx.sh")
    index_file   = filemd5("${path.module}/files/index.html")
  }

  provisioner "local-exec" {
    command = "echo Hello World"
  }

  provisioner "file" {
    source      = "${path.module}/files/index.html"
    destination = "/tmp/index.html"

    connection {
      type = "ssh"
      user = "ubuntu"
      host = aws_instance.provisioner.public_ip
    }
  }

  provisioner "remote-exec" {
    script = "${path.module}/files/install-nginx.sh"

    connection {
      type = "ssh"
      user = "ubuntu"
      host = aws_instance.provisioner.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cp /tmp/index.html /var/www/html/index.html"
    ]

    connection {
      type = "ssh"
      user = "ubuntu"
      host = aws_instance.provisioner.public_ip
    }
  }
}
```




