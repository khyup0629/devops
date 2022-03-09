# 모듈 생성하기

일반적으로 모듈은 아래와 같은 구성으로 되어 있습니다.

![image](https://user-images.githubusercontent.com/43658658/157369766-f67fa891-8b0d-4672-863d-13ce0ccdb354.png)   
- account : 모듈 이름(디렉토리)
  - README.md : 모듈 가이드 문서
  - main.tf : resource / data / module / local
  - outputs.tf : output
  - variables.tf : varible
  - versions.tf : provider / module 버전 의존성 

## versions.tf

테라폼, provider의 버전 의존성을 명시하는 파일입니다.

``` terraform
# versions.tf
terraform {
  required_version = ">= 0.15"  # 최소한으로 요구되는 테라폼 버전

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.45"
    }
  }
}
```

## variables.tf

모듈에서 사용되는 변수들의 집합입니다.

``` terraform
# variables.tf
variable "name" {   # AWS 계정의 별칭, aws_iam_account_alias와 연결
  description = "The name for the AWS account. Used for the account alias."
  type        = string
}

variable "password_policy" {   # IAM 유저들의 패스워드 정책, aws_iam_account_password_policy와 연결
  description = "Password Policy for the AWS account."
  type = object({
    minimum_password_length        = number
    require_numbers                = bool
    require_symbols                = bool
    require_lowercase_characters   = bool
    require_uppercase_characters   = bool
    allow_users_to_change_password = bool
    hard_expiry                    = bool
    max_password_age               = number
    password_reuse_prevention      = number
  })
  default = {
    minimum_password_length        = 8
    require_numbers                = true
    require_symbols                = true
    require_lowercase_characters   = true
    require_uppercase_characters   = true
    allow_users_to_change_password = true
    hard_expiry                    = false
    max_password_age               = 0
    password_reuse_prevention      = 0
  }
}
```

## main.tf

모듈의 본체 테라폼 코드입니다.

``` terraform
# main.tf
data "aws_caller_identity" "this" {}


###################################################
# AWS Account Alias
###################################################

resource "aws_iam_account_alias" "this" {
  account_alias = var.name
}


###################################################
# Password Policy for AWS Account and IAM Users
###################################################

resource "aws_iam_account_password_policy" "this" {
  minimum_password_length        = var.password_policy.minimum_password_length
  require_numbers                = var.password_policy.require_numbers
  require_symbols                = var.password_policy.require_symbols
  require_lowercase_characters   = var.password_policy.require_lowercase_characters
  require_uppercase_characters   = var.password_policy.require_uppercase_characters
  allow_users_to_change_password = var.password_policy.allow_users_to_change_password
  hard_expiry                    = var.password_policy.hard_expiry
  max_password_age               = var.password_policy.max_password_age
  password_reuse_prevention      = var.password_policy.password_reuse_prevention
}
```

## outputs.tf

모듈 사용자들이 필요로 하는 output을 적절하게 출력해주는 것이 필요합니다.

``` terraform
# outputs.tf
output "id" {
  description = "The AWS Account ID."
  value       = data.aws_caller_identity.this.account_id
}

output "name" {
  description = "Name of the AWS account. The account alias."
  value       = aws_iam_account_alias.this.account_alias
}

output "signin_url" {
  description = "The URL to signin for the AWS account."
  value       = "https://${var.name}.signin.aws.amazon.com/console"
}

output "password_policy" {
  description = "Password Policy for the AWS Account. `expire_passwords` indicates whether passwords in the account expire. Returns `true` if `max_password_age` contains a value greater than 0."
  value       = aws_iam_account_password_policy.this
}
```

## README.md

=> [테라폼 docs 도구](https://github.com/terraform-docs/terraform-docs)

- `<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->` 아래 부분은 테라폼 docs 도구가 자동으로 생성해주는 부분
- 그 위로는 모듈 창작자가 설명하는 헤더 부분

``` terraform
# README.md
# account

This module creates following resources.

- `aws_iam_account_alias`
- `aws_iam_account_password_policy`

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.45 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.49.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_account_alias.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_account_alias) | resource |
| [aws_iam_account_password_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_account_password_policy) | resource |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | The name for the AWS account. Used for the account alias. | `string` | n/a | yes |
| <a name="input_password_policy"></a> [password\_policy](#input\_password\_policy) | Password Policy for the AWS account. | <pre>object({<br>    minimum_password_length        = number<br>    require_numbers                = bool<br>    require_symbols                = bool<br>    require_lowercase_characters   = bool<br>    require_uppercase_characters   = bool<br>    allow_users_to_change_password = bool<br>    hard_expiry                    = bool<br>    max_password_age               = number<br>    password_reuse_prevention      = number<br>  })</pre> | <pre>{<br>  "allow_users_to_change_password": true,<br>  "hard_expiry": false,<br>  "max_password_age": 0,<br>  "minimum_password_length": 8,<br>  "password_reuse_prevention": 0,<br>  "require_lowercase_characters": true,<br>  "require_numbers": true,<br>  "require_symbols": true,<br>  "require_uppercase_characters": true<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The AWS Account ID. |
| <a name="output_name"></a> [name](#output\_name) | Name of the AWS account. The account alias. |
| <a name="output_password_policy"></a> [password\_policy](#output\_password\_policy) | Password Policy for the AWS Account. `expire_passwords` indicates whether passwords in the account expire. Returns `true` if `max_password_age` contains a value greater than 0. |
| <a name="output_signin_url"></a> [signin\_url](#output\_signin\_url) | The URL to signin for the AWS account. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
```

## 모듈 사용하기

`account` 모듈을 생성한 동일한 폴더에 `main.tf` 파일을 작성합니다.

``` terraform
# main.tf
provider "aws" {
  region = "ap-northeast-2"
}

module "account" {
  source = "./account"   # 로컬 소스로 모듈을 활용하는 방법

  name = "posquit0-fastcampus"   # variable에 있는 name 변수
  password_policy = {   # variable에 있는 password_policy 변수
    minimum_password_length        = 8
    require_numbers                = true
    require_symbols                = true
    require_lowercase_characters   = true
    require_uppercase_characters   = true
    allow_users_to_change_password = true
    hard_expiry                    = false
    max_password_age               = 0
    password_reuse_prevention      = 0
  }
}

# account 모듈에서 outputs.tf에 설정한 변수들 이름으로 호출

output "id" {
  value = module.account.id
}

output "account_name" {
  value = module.account.name
}

output "signin_url" {
  value = module.account.signin_url
}

output "account_password_policy" {
  value = module.account.password_policy
}
```








