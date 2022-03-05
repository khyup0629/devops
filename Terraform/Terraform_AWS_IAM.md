# AWS IAM 사용자 생성하기


=> **[Terraform IAM 사용자 생성 참고 자료](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user)**

``` terraform
provider "aws" {
  region = "ap-northeast-2"
}

variable "users" {
  type = set(string)   # set(string)을 통해 리스트의 값들을 문자열로 지정. for_each문에서 toset([])의 역할 수행.
  default = [   # 디폴트 값으로 리스트 형태를 취해줍니다.
    "user-01",
    "user-02",
    "user-03",
  ]
}

locals {   # 로컬 변수로 태그를 선언합니다.
  common_tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_user" "lb" {
  for_each = var.users   # toset([])에 대한 작업은 variable에서 진행되었기 때문에 변수만 호출합니다.

  name = each.key
  path = "/system/"
  
  tags = local.common_tags   # 로컬 변수로 선언한 태그를 호출합니다.
}

resource "aws_iam_access_key" "lb" {
  for_each = var.users   # 액세스 키를 사용자별로 할당
  
  user = aws_iam_user.lb[each.key].name   # aws_iam_user.lb는 딕셔너리 형태이므로 [each.key] 형태로 호출합니다.
}

resource "aws_iam_user_policy" "lb_ro" {
  for_each = var.users   # 정책을 사용자별로 할당
  
  name = "test"
  user = aws_iam_user.lb[each.key].name
  
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

output "iam_user_access_key" {
  value = {for k, v in aws_iam_access_key.lb: k => v.id}
}
```   
![image](https://user-images.githubusercontent.com/43658658/156288725-a6a6ea0a-f8e7-4a93-800d-a2bd64625c3a.png)

## 그룹 생성 및 사용자 그룹에 추가하기

=> **[for문, 조건문을 활용한 IAM 사용자 생성 및 그룹 추가](https://github.com/khyup0629/devops/blob/main/Terraform/Terraform_For.md#for%EB%AC%B8%EC%9D%84-%EC%9D%B4%EC%9A%A9%ED%95%B4-aws-iam-%EC%82%AC%EC%9A%A9%EC%9E%90-%EC%83%9D%EC%84%B1%ED%95%B4%EB%B3%B4%EA%B8%B0)**

## AWS IAM 초기 인프라 구축

=> **[IAM 초기 인프라 구축]()**
