# For 문

=> [Terraform For 문 사용법](https://www.terraform.io/language/expressions/for)

## 딕셔너리(map) 형식

아래와 같은 for문이 있다고 합시다.   
``` terraform
[for k, v in var.map : length(k) + length(v)]
```

`map`은 딕셔너리 형태입니다.
만약 `map = {"abc" = "a", "abcd" = "abc"}` 라는 key-value가 들어있다면, 

위 for문의 출력 값은 `[4, 7]`이 됩니다.   
- `abc`는 `k`이고 길이는 `3`입니다. `a`는 `v`이고 길이는 `1`입니다. 따라서 `"abc" = "a"`는 `4`라는 결과값을 갖습니다.
- `abcd`는 `k`이고 길이는 `4`입니다. `abc`는 `v`이고 길이는 `3`입니다. 따라서 `"abcd" = "abc"`는 `7`이라는 결과값을 갖습니다.

``` terraform
# main.tf
provider "aws" {
  region = "ap-northeast-2"
}

variable "map" {
  default = {
    abc = "a",
    abcd = "abc"
  }
}

output "print" {
  value = [for k, v in var.map: length(k) + length(v)]
}
```   
![image](https://user-images.githubusercontent.com/43658658/156309134-36ddcd57-d070-4fc3-99ad-e9f5bbec551e.png)

## 리스트 형식

``` terraform
[for i, v in var.list : "${i} is ${v}"]
```

`list` 변수는 리스트 형태입니다.   
만약, `list = [1, 2, 3, 4, 5]`이라면,

위 for문의 출력값은 `["0 is 1", "1 is 2", ... , "4 is 5"]`입니다.   
- `i`는 **인덱스**를 나타냅니다.
- `v`는 **value**를 나타냅니다.

``` terraform
# main.tf
provider "aws" {
  region = "ap-northeast-2"
}

variable "list" {
  default = [1, 2, 3, 4, 5]
}

output "print" {
  value = [for i, v in var.list: "${i} is ${v}"]
}
```   
![image](https://user-images.githubusercontent.com/43658658/156309653-166a309f-5d49-4acc-9282-277e8367abd1.png)

## 결과값 딕셔너리 형식으로 출력

``` terraform
{for s in var.list : s => upper(s)}
```

만약 `list = ["a", "b", "c"]`라면,

결과값의 형태는 `{a = A, b = B, c = C}`가 됩니다.   
- `upper()`는 대문자로 바꿔주는 함수입니다.
- `s => upper(s)`의 출력 형식은 `s = upper(s)`가 됩니다.

``` terraform
# main.tf
provider "aws" {
  region = "ap-northeast-2"
}

variable "list" {
  default = ["a", "b", "c"]
}

output "print" {
  value = {for s in var.list: s => upper(s)}
}
```   
![image](https://user-images.githubusercontent.com/43658658/156310960-bccf3071-b870-4546-9828-aa739283532f.png)

## if문을 적용한 for문

``` terraform
[for s in var.list : upper(s) if s != ""]
```

만약 `list = ["a", "", "b", ""]`이라면,

결과값의 형태는 `["A", "B"]`가 됩니다.   
- `upper(s) if s != ""`는 `s`가 `null`이 아니라면, 대문자로 추가하라는 의미입니다.

``` terraform
# main.tf
provider "aws" {
  region = "ap-northeast-2"
}

variable "list" {
  default = ["a", "", "b", ""]
}

output "print" {
  value = [for s in var.list: upper(s) if s != ""]
}
```   
![image](https://user-images.githubusercontent.com/43658658/156312237-bc5d3637-958d-4067-902f-6a12e428a16f.png)

## for문을 이용해 AWS IAM 사용자 생성해보기

``` terraform
# main.tf
provider "aws" {
  region = "ap-northeast-2"
}

/*
 * Groups
 */

resource "aws_iam_group" "developer" {   # developer라는 이름의 그룹 생성
  name = "developer"
}

resource "aws_iam_group" "employee" {   # employee라는 이름의 그룹 생성
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
 
variable "users" {   # terraform.tfvars에 정의된 값들이 users에 들어갑니다.
  type = list(any)
}

resource "aws_iam_user" "this" {
  # {"john" = {name = "john", level = 7, ... }, ... }의 딕셔너리 형태. key값은 사용자 이름. value값은 name, level, role, is_developer
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
  # 조건문을 이용해 is_developer가 true이면 developer, employee 두 그룹에 모두 추가. false이면 employee 그룹에만 추가.
  # 특정 그룹에 넣고 싶을 때는 groups에 [그룹 이름1, 그룹 이름2, ... ] 리스트 형식으로 그룹 이름을 명시합니다.
  groups = each.value.is_developer ? [aws_iam_group.developer.name, aws_iam_group.employee.name] : [aws_iam_group.employee.name]
}
```

``` terraform
# terraform.tfvars
users = [
  {
    name = "john"
    level = 7
    role = "재무"
    is_developer = false
  },
  {
    name = "alice"
    level = 1
    role = "인턴 개발자"
    is_developer = true
  },
  {
    name = "tony"
    level = 4
    role = "데브옵스"
    is_developer = true
  },
  {
    name = "cindy"
    level = 9
    role = "경영"
    is_developer = false
  },
  {
    name = "hoon"
    level = 3
    role = "마케팅"
    is_developer = false
  },
]
```

```
tf init
tf apply
```   
![image](https://user-images.githubusercontent.com/43658658/156313925-4983e053-c79b-4b07-8782-b4491d63740d.png)   
![image](https://user-images.githubusercontent.com/43658658/156313973-94d8ab7c-d12b-4499-9cb7-c937746e3975.png)   
![image](https://user-images.githubusercontent.com/43658658/156314081-83b50fa8-fc37-4900-bd45-ce7ba868b5a3.png)   
- `terraform.tfvars` 파일의 각 사용자들의 인자들 중 `is_developer = true`인 사용자는 `developer`, `employee` 두 그룹에 추가.
- `terraform.tfvars` 파일의 각 사용자들의 인자들 중 `is_developer = true`인 사용자는 `employee` 그룹에만 추가.
- `for_each`문 안에 `for`문을 넣어 딕셔너리 형태로 만들어주는 트릭이 인상 깊습니다.

**개발자**에게만 관리자접근을 허용하는 정책을 추가해보겠습니다.

``` terraform

...

locals {
  developers = [
    for user in var.users:
    user
    if user.is_developer
  ]
}

resource "aws_iam_user_policy_attachment" "developer" {
  for_each = {
    for developer in local.developers:
    developer.name => developer
  }
  
  user = each.key   # 해당 이름의 사용자에게 아래의 관리자접근(AdministratorAccess) 정책을 허용합니다.
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  
  depends_on = [   # aws_iam_user.this 리소스가 생성되어 있을 때만 해당 리소스를 실행한다는 의존성 속성입니다.
    aws_iam_user.this
  ]
}

output "developers" {
  value = local.developers
}

output "high_level_users" {
  value = [
    for user in var.users:
    user
    if user.level > 5
  ]
}
```

```
tf apply
```   
![image](https://user-images.githubusercontent.com/43658658/156317030-14839be0-be01-4c92-93cd-0fdef1c356ce.png)   
- 개발자 사용자에는 `관리자 권한`이 부여된 것을 확인할 수 있습니다.

![image](https://user-images.githubusercontent.com/43658658/156317384-f3504025-638e-4478-a383-01d0d9aa04d4.png)   
- 개발자가 아닌 사용자에게는 `관리자 권한`이 부여되지 않았습니다.

