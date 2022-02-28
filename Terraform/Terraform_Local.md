# Terraform Local 

Local 변수 선언 형식
```
locals {
  <local name> = value
}
```   
- locals 블럭 안에 선언한 변수를 조회하는 방법은 `local.<local name>`입니다.

예를 들어, 리소스마다 같은 태그를 넣고 싶다면, **locals**에 태그를 명시하고 **각 리소스에서 조회**하면 됩니다.   
```
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

  tags = local.common_tags   # local 변수를 조회해서 태그 값으로 넣을 수 있습니다.
}
```

