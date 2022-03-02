# AWS IAM 사용자 생성하기


=> **[Terraform IAM 사용자 생성 참고 자료](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user)**

``` terraform
provider "aws" {
  region = "ap-northeast-2"
}

locals = {
  common_tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_user" "lb" {
  for_each = toset{[
    "user-01",
    "user-02",
    "user-03",
  ]}

  name = each.key
  path = "/system/"
  
  tags = local.common_tags
}

resource "aws_iam_access_key" "lb" {
  user = values(aws_iam_user.lb).*.name
}

resource "aws_iam_user_policy" "lb_ro" {
  name = "test"
  user = values(aws_iam_user.lb).*.name
  
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
```
