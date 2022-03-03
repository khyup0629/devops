## state 명령어

본 자료는 [테라폼 원격 Backend(Terraform Cloud)]() 이후에 이어지는 내용입니다.

`terraform state` : 고급 상태 관리 명령어

먼저 아래와 같은 `main.tf` 코드를 작성합니다.   

``` terraform
# main.tf
terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "Test-terraform-cloud-bllu"

    workspaces {
      name = "tf-cloud-backend"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

/*
 * Groups
 */

resource "aws_iam_group" "this" {
  for_each = toset(["developer", "employee"])

  name = each.key
}

output "groups" {
  value = aws_iam_group.this
}


/*
 * Users
 */

variable "users" {
  type = list(any)
}

resource "aws_iam_user" "this" {
  for_each = {
    for user in var.users :
    user.name => user
  }

  name = each.key

  tags = {
    level = each.value.level
    role  = each.value.role
  }
}

resource "aws_iam_user_group_membership" "this" {
  for_each = {
    for user in var.users :
    user.name => user
  }

  user   = each.key
  groups = each.value.is_developer ? [aws_iam_group.this["developer"].name, aws_iam_group.this["employee"].name] : [aws_iam_group.this["employee"].name]
}

locals {
  developers = [
    for user in var.users :
    user
    if user.is_developer
  ]
}

output "developers" {
  value = local.developers
}

output "high_level_users" {
  value = [
    for user in var.users :
    user
    if user.level > 5
  ]
}
```

```
tf init
tf apply
```

위 코드를 적용하면, `Terraform cloud`의 해당 `Organization`에 원격으로 올라갑니다.

아래의 명령어는 현재 워크스페이스에서 생성된 리소스들에 대해 결과값으로 보여줍니다.   
```
tf state list
```   
![image](https://user-images.githubusercontent.com/43658658/156481485-d76b4dde-e187-4035-b685-8b7ebdbc84ce.png)

이는 `Terraform Cloud`의 `Workspace > Overview > Resources`에 명시된 것들과 같습니다.   
![image](https://user-images.githubusercontent.com/43658658/156481637-e4101fbf-91bd-498d-ae57-6d1ae9aa7b24.png)


