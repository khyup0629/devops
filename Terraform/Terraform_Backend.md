# Backend(State Storage)

- **Local State** : `terraform.tfstate` - 개인 작업만 가능
- **Remote State** : `Backend(State Storage)` - 협업이 용이. 동시성 Issue가 발생할 우려가 높아짐.
  * **Local Backend**
  * **Remote Backend** : `Terraform Cloud`
  * **AWS S3 Backend(with / without DynamoDB)** - (락 기능 O / 락 기능 X)

`Locking` 기능 : 동시다발적으로 코드가 실행되는 것을 막기 위해 한 명을 제외한 나머지 사용자에게는 실행을 막아버리는 기능.

## AWS S3 Backend

먼저 `AWS 콘솔`에서 **버킷을 생성**합니다.   
![image](https://user-images.githubusercontent.com/43658658/156328081-165da8ca-f10a-4d22-8203-42929373b396.png)

`main.tf` 파일 맨 위에 다음 코드를 추가합니다.   
``` terraform
# main.tf
terraform {
  backend "s3" {
    bucket = "bllu-terraform-backend"   # 글로벌 Unique : 글로벌적으로 고유한 버킷 이름
    key = "s3-backend/terraform.tfstate"   # S3 내의 path로 상태 파일을 저장하는 경로입니다.
    region = "ap-northeast-2"   # 버킷이 위치한 리전
  }
}
```

콘솔에서 생성한 S3 버킷과 연동하기 위해 **테라폼 초기화**를 진행합니다.   
```
tf init
```   

테라폼 초기화를 진행하면 아래와 같이 `key` 아규먼트에 지정한 경로로 파일이 생성됩니다.   
![image](https://user-images.githubusercontent.com/43658658/156331620-34d0180b-5167-4cb0-8947-030b7a1ae3cf.png)   
- 버킷에 `s3-backend` 폴더가 생성됩니다.
- 그 안에 `terraform.tfstate` 파일이 생성됩니다.
![image](https://user-images.githubusercontent.com/43658658/156331762-d925a63e-dd09-4ca0-a5a9-fab4034bad9b.png)

## Remote Backend(Terraform Cloud)

=> **[Terraform Cloud 회원가입](https://app.terraform.io/session)**

**Terraform Cloud** 페이지로 접속해서 `Free account`를 눌러 회원가입을 진행합니다.   
![image](https://user-images.githubusercontent.com/43658658/156332213-3fc08014-36ad-4212-8782-ce58304debdb.png)

**이메일 인증** 까지 완료되면 아래와 화면이 나타납니다. `Organization`을 생성하기 위해 `Start from scratch`를 클릭합니다.   
![image](https://user-images.githubusercontent.com/43658658/156333164-915d6f4d-c8ba-4f76-8510-3c27618f7d42.png)
![image](https://user-images.githubusercontent.com/43658658/156333264-16cb51a1-9862-4064-9ac7-74b2f9405bf8.png)

다음으로 `Token`을 등록하는 과정입니다.   
![image](https://user-images.githubusercontent.com/43658658/156333900-1888616f-8767-4740-9dc6-fa0334436923.png)   
![image](https://user-images.githubusercontent.com/43658658/156333965-90c8487c-8de8-4f0b-a0f5-0ebe9a98db3b.png)
![image](https://user-images.githubusercontent.com/43658658/156334016-a1c86108-475e-4ded-90fb-c7160705b74f.png)

생성된 토큰을 복사합니다.   
![image](https://user-images.githubusercontent.com/43658658/156334121-012f92d6-950b-46ac-8271-a588eeb31dbf.png)

`~/.terraformrc` 파일에 자격증명을 아래와 같이 작성하고, 발급받은 토큰을 붙여넣습니다.   
```
vim ~/.terraformrc
```

``` terraform
# .terraformrc
plugin_cache_dir   = "$HOME/.terraform.d/plugin-cache"

credentials "app.terraform.io" {
  token = "<<발급받은 API 토큰>>"
}
```

이제 `main.tf` 파일의 최상단에 아래와 같이 추가합니다.   
``` terraform
# main.tf
terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "Test-terraform-cloud-bllu"   # 자신이 생성한 Organization 이름을 입력합니다.

    workspaces {
      name = "tf-cloud-backend"   # 원하는 Terraform Cloud의 워크스페이스 이름을 입력합니다.
    }
  }
}
```

`Terraform Cloud`의 `Organization`과 연동하기 위해 **테라폼을 초기화**합니다.   
```
tf init
```   

Terraform Cloud 브라우저로 접속하면 해당 Organization에 워크스페이스가 생성된 것을 확인할 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/156334880-0ea02550-8066-4960-9b03-aa3854fa431d.png)

워크스페이스의 `General Settings`로 접근합니다.   
![image](https://user-images.githubusercontent.com/43658658/156335237-75bfc1b1-7224-4302-bf18-13e6de9c7eda.png)

`Execution Mode`를 `Local`로 변경합니다.   
![image](https://user-images.githubusercontent.com/43658658/156335340-3c95eff6-ed2b-4f34-b0f2-44f35b67220a.png)

이제 아래의 테라폼 코드를 **apply**합니다.   
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

정상적으로 **apply**되면 `Overview` 탭에서 아래와 같이 CLI에서 확인하던 `Resource`와 `output`을 확인할 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/156335776-2c2a30f2-be77-4ffa-b94a-ffb694a32fff.png)   
![image](https://user-images.githubusercontent.com/43658658/156335813-fb92d00c-795a-4508-b1f4-9a9a047ee2c0.png)

`States` 탭에서 **현재 워크스페이스의 상태**를 확인할 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/156335958-08f9116f-593e-4156-8f94-3aba2f5c8ba2.png)

