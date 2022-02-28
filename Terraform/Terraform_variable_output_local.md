# 테라폼 variable 블럭

- variable 선언 형식   
``` terraform
variable "<variable name>" {}
```

```
# main.tf
provider "aws" {
  region = "ap-northeast-2"
}

variable "vpc_name" {}

module "vpc" {
  source  = "tedilabs/network/aws//modules/vpc"
  version = "0.24.0"

  name                  = var.vpc_name   # `var.<variable name>`을 통해 variable 블럭을 참조할 수 있습니다.
  cidr_block            = "10.0.0.0/16"

  internet_gateway_enabled = true

  dns_hostnames_enabled = true
  dns_support_enabled   = true

  tags = {}
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

  tags = {}
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
      gateway_id = module.vpc.internet_gateway_id
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

  ipv4_routes = []

  tags = {}
}
```

> <h3>환경변수 선언</h3>

`TF_VAR_`를 변수이름 앞에 붙여 환경 변수로 선언할 수 있습니다.   
```
export TF_VAR_<variable name>="value"
```

환경 변수는 `unset`을 통해 해제할 수 있습니다.   
```
unset TF_VAR_<variable name>
```

실습해봅시다.   
```
export TF_VAR_vpc_name="bllu"
tf apply
```

bllu라는 이름의 vpc가 생성됩니다.   
![image](https://user-images.githubusercontent.com/43658658/155937585-9774d1a9-5d23-41e5-9684-0a93819c3fa5.png)

환경 변수를 해제합니다.   
```
unset TF_VAR_vpc_name
```

> <h3>terraform.tfvars 파일로 선언</h3>

`terraform.tfvars` 파일은 `terraform` 명령어를 실행할 때 자동으로 조회됩니다.   
```
vim terraform.tfvars
```

``` terraform
# terraform.tfvars
vpc_name = "test"
```

```
tf apply
```   

`bllu`에서 `test`로 변경되는 것을 확인할 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/155938697-a9b0434d-a613-4e6d-a1e8-53dd63a89cdd.png)

한편, `terraform.tfvars` 파일 이름이 아닌 다른 이름은 자동으로 조회되지 않습니다.   

파일 이름을 임의로 변경하고,   
```
mv terraform.tfvars test.tfvars
```

- 수동으로 조회하는 방법   
```
tf apply -var-file="test.tfvars"
```

- 자동으로 조회하는 방법   
```
mv test.tfvars test.auto.tfvars
tf apply
```

> <h3>명령라인에서 직접 바꾸기</h3>

`tf apply` 명령을 할 때, `-var="<variable name>=value"` 옵션을 주어 변수에 대한 값을 직접 입력할 수 있습니다.   
```
tf apply -var="vpc_name=bllu"
```   
`main.tf` 안에 선언된 variable을 찾아가 값을 `bllu`로 넣습니다.   
![image](https://user-images.githubusercontent.com/43658658/155940005-ed6f1b74-3bcb-46ec-b1d0-41edf60d5b4e.png)

> <h3>Variable 조회 우선 순위</h3>

1. 명령라인(`-var`, `-var-file`)
2. `*.auto.tfvars`
3. `terraform.tfvars`
4. 환경 변수

> <h3>variable의 속성</h3>

- `default` : 변수에 아무 값도 없을 경우 나타나는 값.
- `description` : 설명. 협업할 때 중요.
- `type` : 자료형. 명시적으로 적어줄 필요는 없고, 테라폼이 알아서 추론하지만 협업할 때 중요.

``` terraform
variable "vpc_name" {
  default = "bllu"
  description = "vpc 이름"
  type = string
}
```
