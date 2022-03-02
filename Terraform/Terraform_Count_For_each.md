# Terraform 반복문

## Count

`count`는 아래와 같이 사용할 수 있습니다.

``` terraform
provider "aws" {
  region = "ap-northeast-2"
}

/*
 * count
 */

resource "aws_iam_user" "count" {   # `count` 리소스는 리스트 형식 : [user-0, user-1, user-2, ... , user-9]
  count = 10   # meta-argument : 블럭의 종류에 상관없이 어디에서나 쓸 수 있는 아규먼트. 최상단에 선언하는 것이 관습.

  name = "count-user-${count.index}"   # 0 ~ 9
}

output "count_user_arns" {
  value = aws_iam_user.count.*.arn   # 리스트 형식의 리소스를 모두 출력하기 위해 .*의 형식을 취해줍니다.
}
```

```
tf init
tf apply
```   
![image](https://user-images.githubusercontent.com/43658658/156275979-030c6cad-ab96-47d1-bb58-bb3c30ada2d5.png)

## For_each

`for_each`는 아래와 같이 사용할 수 있습니다.

``` terraform

```


