# 모듈 사용 방법

=> [Terraform 공식 문서](https://www.terraform.io/language/modules/sources)에서 모듈이 위치한 곳에 따라 `source`에 작성하는 방법을 참고합니다.

> <h3>Local Path</h3>

모듈이 로컬에 위치한 경우 아래와 같이 path로 설정할 수 있습니다.   
``` terraform
module "consul" {
  source = "./consul"
}
```

> <h3>Terraform Registry</h3>

모듈이 레지스트리에 위치한 경우 `<NAMESPACE>/<NAME>/<PROVIDER>` 형식으로 참조할 수 있습니다.
``` terraform
module "consul" {
  source = "hashicorp/consul/aws"
  version = "0.1.0"
}
```

프라이빗 레지스트리에 위치한 경우 `<HOSTNAME>/<NAMESPACE>/<NAME>/<PROVIDER>`의 형식으로 참조합니다.   
``` terraform
module "consul" {
  source = "app.terraform.io/example-corp/k8s-cluster/azurerm"
  version = "1.1.0"
}
```

> <h3>GitHub</h3>

깃 리포지토리에 위치했을 때 HTTPS를 통해 가져오는 경우   
``` terraform
module "consul" {
  source = "github.com/hashicorp/example"
}
```

SSH를 통해 가져오는 경우   
``` terraform
module "consul" {
  source = "git@github.com:hashicorp/example.git"
}
```

## 테라폼 리포지토리의 모듈 사용해보기

``` terraform
provider "aws" {
  region = "ap-northeast-2"
}

module "vpc" {   # 모듈 블럭의 형식은 module "<module name>" {}
  source  = "tedilabs/network/aws//modules/vpc"
  version = "0.24.0"

  name                  = "fastcampus"
  cidr_block            = "10.0.0.0/16"

  internet_gateway_enabled = true

  dns_hostnames_enabled = true
  dns_support_enabled   = true

  tags = {}
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

  tags = {}
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

  tags = {}
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
      gateway_id = module.vpc.internet_gateway_id   # vpc가 생성될 때 생성되는 internet gateway에 장착.
    },
  ]

  tags = {}
}

module "route_table__private" {
  source  = "tedilabs/network/aws//modules/route-table"
  version = "0.24.0"

  name   = "${module.vpc.name}-private"
  vpc_id = module.vpc.id

  subnets = module.subnet_group__private.ids

  ipv4_routes = []   # 프라이빗에는 트래픽이 흐르지 않도록.

  tags = {}
}
```
