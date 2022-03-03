# 워크스페이스 관리

- **워크스페이스** : 상태 관리의 단위

## terraform workspace

> <h3>terraform workspace new </h3>

워크스페이스를 생성하는 명령어입니다.

```
tf workspace new prod
```

> <h3>상태 파일 디렉토리 terraform.tfstate.d</h3>

워크스페이스가 여러 개가 되면, 상태 파일(terraform.tfstate) 또한 여러 개가 될 것이므로, 디렉토리 형태로 변경됩니다.   
![image](https://user-images.githubusercontent.com/43658658/156526184-a72eca8f-3c9c-44c5-8f9e-1d53154d9670.png)

`terraform.tfstate.d` 디렉토리 내에 워크스페이스들의 상태 파일이 저장됩니다.   
![image](https://user-images.githubusercontent.com/43658658/156526318-ef3b4b98-9203-44a5-b340-33f9bd7be3e1.png)

`apply`를 하게 되면 상태 파일(.tfstate)이 저장됩니다.

> <h3>terraform workspace show </h3>

현재 활성화된 워크스페이스를 보여줍니다.   

```
tf workspace show
```

- `new`로 생성하면 해당 워크스페이스로 넘어갑니다.

![image](https://user-images.githubusercontent.com/43658658/156525497-dd410bd9-9a4a-480f-8d66-eb5f52822df6.png)

> <h3>terraform workspace list</h3>

전체 워크스페이스 목록을 보여줍니다.

```
tf workspace list
```   

현재 활성화된 워크스페이스는 `*`가 붙어있습니다.   
![image](https://user-images.githubusercontent.com/43658658/156525568-2c3ac038-10b9-4a40-a130-fd9029ec0e53.png)

> <h3>terraform workspace select </h3>

활성화된 워크스페이스를 변경합니다. 

```
tf workspace select default
tf workspace show
```   
![image](https://user-images.githubusercontent.com/43658658/156525880-0d1681cd-881f-4acb-ba4f-3936aef234b0.png)

> <h3>terraform workspace delete</h3>

워크스페이스를 지웁니다.

```
tf workspace delete prod
```

## 서로 다른 워크스페이스에서 tfvars 파일 활용

**서로 다른 워크스페이스**에서 사용할 `.tfvars` 파일을 만들고, 이를 `main.tf` 파일에 적용시켜보겠습니다.

먼저 `main.tf` 파일을 아래와 같이 구성합니다.   
``` terraform
# main.tf
provider "aws" {
  region = "ap-northeast-2"
}

variable "vpc_name" {   # dev.tfvars, prod.tfvars, staging.tfvars 파일의 내용이 적용됩니다.
  description = "생성되는 VPC의 이름"
  type        = string
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

`dev.tfvars`, `prod.tfvars`, `staging.tfvars` 파일을 각각 만듭니다.   
``` terraform
# dev.tfvars
vpc_name = "dev"
```

``` terraform
# prod.tfvars
vpc_name = "prod"
```

``` terraform
# staging.tfvars
vpc_name = "staging"
```

`dev`, `prod`, `staging`에 대해 각각 워크스페이스를 생성합니다.   
```
tf workspace new dev
tf workspace new prod
tf workspace new staging
```

먼저 `dev` 워크스페이스를 선택합니다.   
```
tf workspace select dev
```

`dev.tfvars` 파일을 적용해 `apply`합니다.   
```
tf init
tf apply -var-file=dev.tfvars
```

`AWS 콘솔`을 살펴보면 `dev`가 접두어로 붙은 리소스들이 생성된 것을 볼 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/156528007-c131dee0-4796-4b21-bccb-7ba03bc630e7.png)

이번엔 `staging` 워크스페이스를 선택하고 `staging.tfvars` 파일을 이용해 `apply`합니다.
```
tf workspace select staging
tf apply -var-file=staging.tfvars
```

다른 워크스페이스에서 생성했기 때문에 기존의 `dev`관련 리소스들은 남아있는 상태로 새롭게 `staging` 리소스가 추가된 것을 확인할 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/156528621-62b742a5-bac4-4a5c-82b1-e455ce695694.png)

마지막 남은 `prod`에 대해서도 동일한 작업을 진행합니다.   
```
tf workspace select prod
tf apply -var-file=prod.tfvars
```   
![image](https://user-images.githubusercontent.com/43658658/156529191-3441c944-888d-48aa-a426-b9e464929738.png)

## 유의할 점

1. 항상 작업할 때 내가 작업중인 워크스페이스가 무엇인지 파악하는 것이 중요합니다.

```
tf workspace list
```

2. **Terraform Cloud**의 워크스페이스와 **로컬**에서의 워크스페이스는 **서로 다르게 동작**합니다.

공식 문서를 참고하여, 상태 관리를 해줍시다.







