# Terraform Output

`Output` 형식   
```
output "<output name>" {

}
```

> <h3>Module 조회</h3>

기존에 아래와 같은 `main.tf` 파일이 있습니다.   
``` terraform
provider "aws" {
  region = "ap-northeast-2"
}

variable "vpc_name" {
  default = "bllu"
  description = "vpc 이름"
  type = string
}

locals {
  common_tags = {
    Project = "Network"
    Owner   = "posquit0"
  }
}

module "vpc" {   # 모듈 블럭의 형식은 module "<module name>" {}
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

  name                    = "${module.vpc.name}-public"  # 모듈을 참조할 때는 module.<module name>.<output>
  vpc_id                  = module.vpc.id
  map_public_ip_on_launch = true   # public ip 자동 할당

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
  map_public_ip_on_launch = false   # public ip 자동 할당하지 않음.

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
```

여기서 각 출력값을 조회하기 위해서는 아래와 같은 유형들이 있습니다.   
(`resource` 역시 같은 형식으로 조회할 수 있습니다)   
``` terraform
output "vpc_name" {
  value = module.vpc.name   # vpc 모듈의 name의 결과값을 출력합니다.
}

output "vpc_id" {
  value = module.vpc.id
}

output "vpc_cidr" {
  value = module.vpc.cidr_block
}

output "public_subnet_group" {   # subnet_group__public 모듈의 모든 아규먼트의 값을 출력합니다.
  value = module.subnet_group__public
}

output "subnet_group" {
  value = {
    public = module.subnet_group__public
    private = module.subnet_group__private
  }
}
```

> <h3>output의 아규먼트</h3>

- `description` : 설명. 협업을 위해 필수.

``` terraform
output "subnet_group" {
  value = module.vpc.cidr_block
  description = "VPC 모듈의 CIDR"
}
```
