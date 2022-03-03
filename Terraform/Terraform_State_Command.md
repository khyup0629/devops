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

resource "aws_iam_group" "developer" {
  name = "developer"
}

resource "aws_iam_group" "employee" {
  name = "employee"
}

output "groups" {
  value = [
    aws_iam_group.developer,
    aws_iam_group.employee,
  ]
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
  groups = each.value.is_developer ? [aws_iam_group.developer.name, aws_iam_group.employee.name] : [aws_iam_group.employee.name]
}

locals {
  developers = [
    for user in var.users :
    user
    if user.is_developer
  ]
}

resource "aws_iam_user_policy_attachment" "developer" {
  for_each = {
    for user in local.developers :
    user.name => user
  }

  user       = each.key
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"

  depends_on = [
    aws_iam_user.this
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

## terraform state list

아래의 명령어는 현재 워크스페이스에서 생성된 리소스들에 대해 결과값으로 보여줍니다.   
```
tf state list
```   
![image](https://user-images.githubusercontent.com/43658658/156481485-d76b4dde-e187-4035-b685-8b7ebdbc84ce.png)

이는 `Terraform Cloud`의 `Workspace > Overview > Resources`에 명시된 것들과 같습니다.   
![image](https://user-images.githubusercontent.com/43658658/156481637-e4101fbf-91bd-498d-ae57-6d1ae9aa7b24.png)

## terraform state mv

해당 명령어는 코드 수정 시 리소스를 삭제 -> 생성하는 경우를 방지합니다.

기존 `main.tf` 파일의 코드가 아래와 같다고 해봅시다.   
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

resource "aws_iam_group" "developer" {
  name = "developer"
}

resource "aws_iam_group" "employee" {
  name = "employee"
}

output "groups" {
  value = [
    aws_iam_group.developer,
    aws_iam_group.employee,
  ]
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
  groups = each.value.is_developer ? [aws_iam_group.developer.name, aws_iam_group.employee.name] : [aws_iam_group.employee.name]
}

locals {
  developers = [
    for user in var.users :
    user
    if user.is_developer
  ]
}

resource "aws_iam_user_policy_attachment" "developer" {
  for_each = {
    for user in local.developers :
    user.name => user
  }

  user       = each.key
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"

  depends_on = [
    aws_iam_user.this
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
tf apply
```

기존 코드에서 `developer`, `employee` 두 그룹을 생성할 때 `for_each`를 이용해 한 번에 생성하도록 리팩토링합니다.   
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

그리고 다시 **apply**시켜 보면 기존 리소스를 **삭제 -> 생성**하는 과정으로 나타납니다.   
```
tf apply
```   
![image](https://user-images.githubusercontent.com/43658658/156513896-17d24a6c-c5aa-477e-8239-98276652cc83.png)   
![image](https://user-images.githubusercontent.com/43658658/156513503-368a90ee-b2d1-4871-997e-ab9b789bd0ec.png)

**삭제 -> 생성**하는 과정을 없애는 방법이 있습니다. 먼저, `list` 명령어를 통해 리소스를 확인해봅니다.   
```
tf state list
```   

해당 두 리소스가 **삭제 -> 생성**되는 것을 확인할 수 있습니다.
![image](https://user-images.githubusercontent.com/43658658/156513801-ef2b3dd0-2bd8-41d0-8c03-b5cbc397401e.png)

`mv` 명령어를 통해 바꿔줍니다.   
```
tf state mv 'aws_iam_group.developer' 'aws_iam_group.this["developer"]'
tf state mv 'aws_iam_group.employee' 'aws_iam_group.this["employee"]'
```

다시 **apply**를 적용해봅니다.   
```
tf apply
```

**삭제 -> 생성** 과정 없이 리소스가 변경된 것을 확인할 수 있습니다.
![image](https://user-images.githubusercontent.com/43658658/156514463-41c33ce5-cf26-4715-86fc-ed97c6e3cbe3.png)

## terraform state rm

테라폼으로 관리하는 리소스 중 **리소스를 유지**하지만 **테라폼으로 관리를 원하지 않는 경우** 이용합니다.

위에서 사용한 코드를 그대로 이용합니다.   

`list` 명령어로 리소스 명을 살펴봅니다.   
```
tf state list
```

`alice` 유저에게 줬던 **관리자 권한**을 지워보겠습니다.   
![image](https://user-images.githubusercontent.com/43658658/156515505-dc203f3d-c67e-4c51-ba73-b36382bb9a04.png)

먼저, `main.tf` 파일에서 해당 내용을 지웁니다.   
![image](https://user-images.githubusercontent.com/43658658/156516521-8b45a4d7-7b4c-4f52-a8b0-b9bcb15c9977.png)

그리고 `rm` 명령어를 통해 리소스를 지웁니다.   
```
tf state rm 'aws_iam_user_policy_attachment.developer["alice"]'
```

마지막으로 **apply**를 적용해봅니다.   
```
tf apply
```

결과를 살펴보면 `AWS 콘솔`에는 여전히 데이터가 남아있지만, `terraform state list`를 실행하면 해당 리소스가 지워진 것을 확인할 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/156515908-b422539e-40a7-4e80-b55a-9d6c67cf784e.png)   
![image](https://user-images.githubusercontent.com/43658658/156515936-1575e28b-2aa7-445d-9deb-ecd9ee1403b3.png)

## terraform state pull

**Remote Backend**에서 **상태 파일**을 로컬로 끌어옵니다.

```
tf state pull > a.tfstate
```





