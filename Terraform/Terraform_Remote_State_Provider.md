# Terraform Remote State

=> [terraform_remote_state Provider Documentation](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state)

테라폼에서 공식 Provider로 지정할 만큼 굉장히 중요한 역할을 합니다.

multi workspace 환경에서 인프라를 관리한다면 워크스페이스가 굉장히 다양해집니다.   
이렇게 되면, 워크스페이스마다 의존성이 생길 수 있습니다.   
의존성이 있는 워크스페이스의 Attribute를 참조할 때 이용할 수 있습니다.

워크스페이스는 저마다 하나의 상태 파일(tfstate)를 가지고 있습니다.

## Backend 별 사용법이 다르다.

`terraform_remote_state`는 Backend 별로 사용법이 다릅니다.

해당 내용은 아래의 사이트를 참고합니다.   
=> [Backend 별 사용법](https://www.terraform.io/language/settings/backends)

`local`, `remote`, `s3` 등 backend 별로 사용법을 참고합니다.   
![image](https://user-images.githubusercontent.com/43658658/157384795-efc78023-b50c-46ca-a434-6b41055c2ddd.png)

## Network와 EC2에 대한 테라폼 코드 작성

먼저 Network 디렉토리를 생성하고 `main.tf`, `terraform.tfvars` 코드를 작성합니다.   
``` terraform
# main.tf
provider "aws" {
  region = "ap-northeast-2"
}

variable "vpc_name" {
  description = "생성되는 VPC의 이름"
  type        = string
  default     = "default"
}

locals {
  common_tags = {
    Project = "Network"
    Owner   = "posquit0"
  }
}

output "vpc_name" {
  value = module.vpc.name
}

output "vpc_id" {
  value = module.vpc.id
}

output "vpc_cidr" {
  description = "생성된 VPC의 CIDR 영역"
  value = module.vpc.cidr_block
}

output "subnet_groups" {
  value = {
    public  = module.subnet_group__public
    private = module.subnet_group__private
  }
}

module "vpc" {
  source  = "tedilabs/network/aws//modules/vpc"
  version = "0.24.0"

  name                  = var.vpc_name
  cidr_block            = "10.0.0.0/16"

  internet_gateway_enabled = true

  dns_hostnames_enabled = true
  dns_support_enabled   = true

  tags = local.common_tags
}

module "subnet_group__public" {
  source  = "tedilabs/network/aws//modules/subnet-group"
  version = "0.24.0"

  name                    = "${module.vpc.name}-public"
  vpc_id                  = module.vpc.id
  map_public_ip_on_launch = true

  subnets = {
    "${module.vpc.name}-public-001/az1" = {
      cidr_block           = "10.0.0.0/24"
      availability_zone_id = "apne2-az1"
    }
    "${module.vpc.name}-public-002/az2" = {
      cidr_block           = "10.0.1.0/24"
      availability_zone_id = "apne2-az2"
    }
  }

  tags = local.common_tags
}

module "subnet_group__private" {
  source  = "tedilabs/network/aws//modules/subnet-group"
  version = "0.24.0"

  name                    = "${module.vpc.name}-private"
  vpc_id                  = module.vpc.id
  map_public_ip_on_launch = false

  subnets = {
    "${module.vpc.name}-private-001/az1" = {
      cidr_block           = "10.0.10.0/24"
      availability_zone_id = "apne2-az1"
    }
    "${module.vpc.name}-private-002/az2" = {
      cidr_block           = "10.0.11.0/24"
      availability_zone_id = "apne2-az2"
    }
  }

  tags = local.common_tags
}

module "route_table__public" {
  source  = "tedilabs/network/aws//modules/route-table"
  version = "0.24.0"

  name   = "${module.vpc.name}-public"
  vpc_id = module.vpc.id

  subnets = module.subnet_group__public.ids

  ipv4_routes = [
    {
      cidr_block = "0.0.0.0/0"
      gateway_id = module.vpc.internet_gateway_id
    },
  ]

  tags = local.common_tags
}

module "route_table__private" {
  source  = "tedilabs/network/aws//modules/route-table"
  version = "0.24.0"

  name   = "${module.vpc.name}-private"
  vpc_id = module.vpc.id

  subnets = module.subnet_group__private.ids

  ipv4_routes = []

  tags = local.common_tags
}
```

``` terraform
# terraform.tfvars
vpc_name = "remote-state"
```

다음으로 EC2 디렉토리르 만들고 `main.tf`를 작성합니다.

``` terraform
# main.tf
provider "aws" {
  region = "ap-northeast-2"
}

data "terraform_remote_state" "network" {
  backend = "local"

  config = {
    path = "${path.module}/../network/terraform.tfstate"
  }
}

locals {
  vpc_name      = data.terraform_remote_state.network.outputs.vpc_name
  subnet_groups = data.terraform_remote_state.network.outputs.subnet_groups
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

resource "aws_instance" "ubuntu" {
  ami           = data.aws_ami.ubuntu.image_id
  instance_type = "t2.micro"
  subnet_id     = local.subnet_groups["public"].ids[0]


  tags = {
    Name = "${local.vpc_name}-ubuntu"
  }
}
```

EC2 코드는 Network에 대해 의존성이 있습니다.   
Network가 생성되어야 그 안에 EC2-instance가 생성되기 때문입니다.

먼저 Network 폴더로 접근해 `apply` 합니다.   
```
terraform init
terraform apply
```





