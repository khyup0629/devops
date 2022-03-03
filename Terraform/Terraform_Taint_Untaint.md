## Taint

리소스를 강제로 교체해야 할 일이 생겼을 때 `Taint`를 걸어둘 수 있습니다.

`apply`할 때 `taint`가 걸린 리소스를 그 리소스와 연관된 자식들까지 모두 교체합니다.

먼저 아래의 `main.tf` 파일을 실행합니다.   
```
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

```
tf init
tf apply
```

워크스페이스의 리소스를 살펴봅니다.   
```
tf state list
```   
![image](https://user-images.githubusercontent.com/43658658/156522227-7505b1c8-8cb7-4e99-9e3e-fe33d3499073.png)

만약 인터넷 게이트웨이를 교체해야 한다면 아래와 같이 인터넷 게이트웨이 리소스에 `taint`를 걸어둘 수 있습니다.   
```
tf taint 'module.vpc.aws_internet_gateway.this[0]`
```

그리고 다시 `apply`를 진행하게 되면, `taint`가 걸린 리소스를 명시하면서 교체한다는 문구가 출력됩니다.   
```
tf apply
```   
![image](https://user-images.githubusercontent.com/43658658/156521266-f9bc6297-acb9-4483-bd65-b7ba7fe6e64d.png)

## Untaint

만약 해당 리소스를 교체할 때 다른 오류를 야기할 것 같아 `taint`를 취소해야 할 경우가 생깁니다.

그때는 `untaint` 명령어를 사용합니다.   
```
tf untaint 'module.vpc.aws_internet_gateway.this[0]'
```

## terraform apply -replace

`apply`할 때 옵션으로 `-replace`를 줘도 교체가 가능합니다.
```
tf apply -replace 'module.vpc.aws_internet_gateway.this[0]'
```

## 요약

- 한 가지 리소스만 강제 교체 : `terraform apply -replace '<리소스명>'`
- 두 가지 이상 리소스 강제 교체 : `terraform taint '<리소스명>'`


