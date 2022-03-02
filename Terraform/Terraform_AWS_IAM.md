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
  user = aws_iam_user.lb["user-01"].name   # aws_iam_user.lb는 딕셔너리 형태이므로 ["user-01"] 형태로 호출합니다.
}

resource "aws_iam_user_policy" "lb_ro" {
  name = "test"
  user = aws_iam_user.lb["user-01"].name
  
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"vim 
    }
  ]
}
EOF
}
```

현재로서는 액세스 키와 정책을 생성할 때 유저를 생성할 때처럼 반복을 활용해서 효율적으로 생성할 수 있는 방법을 모르겠습니다.
