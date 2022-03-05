# AWS IAM Infra Management with Terraform

## 디렉토리 나누기

1. 그룹 작업과 관련된 디렉토리 생성
2. 사용자 작업과 관련된 디렉토리 생성

![image](https://user-images.githubusercontent.com/43658658/156876423-6fc4e40d-bbf8-4c3a-af1e-227a6b704540.png)   

## 워크스페이스, 변수 파일 나누기

각 디렉토리 내에서 날짜 기준으로 워크스페이스, `.tfvars` 파일 나누기

- 그룹 작업 디렉토리 내의 워크스페이스   
![image](https://user-images.githubusercontent.com/43658658/156876454-0868adfc-cb7c-4235-86bd-d0511910978c.png)   

- 사용자 작업 디렉토리 내의 워크스페이스   
![image](https://user-images.githubusercontent.com/43658658/156876485-7de78cec-cd62-44bc-8707-41d6203fd291.png)

## 해당 날짜의 워크스페이스에서 작업

각 날짜의 워크스페이스로 접속해 그 날짜의 `.tfvars` 파일을 이용해 `apply` 진행.

< 예 >   
```
tf workspace select 220305
tf apply -var-file=220305.tfvars
```

## 소스 코드

1. 그룹 작업

``` terraform
# main.tf
provider "aws" {
  region = "ap-northeast-2"
}

# terraform.tfvars
variable "group_name" {
  type = set(string)
  description = "그룹이름"
}

resource "aws_iam_group" "this" {
  for_each = var.group_name

  name = each.key
}

resource "aws_iam_group_policy_attachment" "MTS_TEAM" {
  group = aws_iam_group.this["MTS_TEAM"].name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

output "group_list" {
  value = [for v in aws_iam_group.this: v.name]
}
```

``` terraform
# 220305.tfvars
group_name = [
  "MTS_TEAM",
  "NWZ",
  "STW",
]
```

2. 사용자 작업

``` terraform
# main.tf
provider "aws" {
  region = "ap-northeast-2"
}

# terraform.tfvars
variable "users" {
  type = list(any)
  description = "사용자 정보"
}

resource "aws_iam_user" "this" {
  for_each = {
    for user in var.users:
    user.name => user
  }

  name = each.key

  tags = {
    real_name = each.value.real_name
    group = each.value.group
  }
}

resource "aws_iam_user_group_membership" "this" {
  for_each = {
    for user in var.users:
    user.name => user
  }

  user = each.key
  groups = [each.value.group]

  depends_on = [
    aws_iam_user.this
  ]
}

locals {
  MTS_TEAM_user = [
    for user in var.users:
    user
    if user.group == "MTS_TEAM"
  ]
}

resource "aws_iam_user_policy_attachment" "this" {
  for_each = {
    for mts_user in local.MTS_TEAM_user:
    mts_user.name => mts_user
  }

  user = each.key
  policy_arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"

  depends_on = [
    aws_iam_user.this
  ]
}

resource "aws_iam_user_login_profile" "this" {
  for_each = {
    for user in var.users:
    user.name => user
  }

  user    = each.key
  password_reset_required = true

  depends_on = [
    aws_iam_user.this
  ]
}

output "password" {
  value = {for k, password in aws_iam_user_login_profile.this: k => password.password}
}
```

``` terraform
# 220305.tfvars
users = [
  {
    name = "khyup0629@hongikit.com"
    real_name = "김협"
    group = "MTS_TEAM"
  },
  {
    name = "dowon0707@gmail.com"
    real_name = "김도원"
    group = "MTS_TEAM"
  }
]
```

``` terraform
# 220306.tfvars
users = [
  {
    name = "khyup0629@hongikit.com"
    real_name = "김협"
    group = "MTS_TEAM"
  },
  {
    name = "dowon0707@gmail.com"
    real_name = "김도원"
    group = "MTS_TEAM"
  }
]
hyeob@hyeob:~/hongikit-aws-terraform/iam-user$ cat 220306.tfvars
users = [
  {
    name = "ljhun307@hongikit.com"
    real_name = "이장훈"
    group = "MTS_TEAM"
  },
]
```

## 해당 방식으로 작업 시 장점

- 워크스페이스를 나눠서 작업해 다른 워크스페이스의 영향을 받지 않고 그룹과 사용자를 그때그때 추가 가능.
- 하나의 `main.tf` 파일을 여러 `.tfvars` 파일이 공유하는 구조를 갖춰 효율적.
- 동일한 내용의 반복 작업 수행 시 빠르게 작업 수행 가능.

## 해당 방식으로 작업 시 단점

- 초기 스크립트 작성에 시간 투자 필요.
- 파일이 많아지면 나중에 리소스를 수정해야 할 때 찾기가 힘듦.
- 사용자 계정을 생성하고 해당 사용자가 로그인한 뒤 사용자에 대한 정보를 수정하게 되면 더이상 해당 테라폼 코드는 사용 불가능.   
(그룹, 사용자 생성에만 특화)
