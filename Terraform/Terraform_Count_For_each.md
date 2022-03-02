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

`count`는 만약 중간 인덱스의 데이터를 삭제해야 할 경우 중간 이후의 인덱스들이 삭제되었다가 한 칸씩 앞으로 당겨져서 생성되는 과정이 발생하면서 문제가 될 수 있습니다.

## For_each

> <h3>for_each_set</h3>

`for_each`는 아래와 같이 사용할 수 있습니다.

``` terraform
provider "aws" {
  region = "ap-northeast-2"
}

/*
 * for_each
 */

resource "aws_iam_user" "for_each_set" {   # 리소스의 결과는 name:for_each의 key:value 형식으로 나옵니다.
  for_each = toset([   # toset은 리스트 형태를 형변환
    "for-each-set-user-1",
    "for-each-set-user-2",
    "for-each-set-user-3",
  ])

  name = each.key   # set형식의 경우 each.key, each.value해도 같은 결과가 나옵니다. 
}

output "for_each_set_user_arns" {
  value = values(aws_iam_user.for_each_set).*.arn   # 리소스의 결과가 key:value 형식이기 때문에 values() 형식을 취해주셔야 합니다. values()의 결과값은 리스트 형식입니다. 따라서 *를 이용해 모든 결과값을 출력합니다.
}
```   
![image](https://user-images.githubusercontent.com/43658658/156277693-6927b268-59d7-439e-8271-f604fe949b02.png)


> <h3>for_each_map</h3>

``` terraform
provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_iam_user" "for_each_map" {
  for_each = {   # 반드시 key는 string 자료형이어야 합니다.
    alice = {
      level = "low"
      manager = "posquit0"
    }
    bob = {
      level = "mid"
      manager = "posquit0"
    }
    john = {
      level = "high"
      manager = "steve"
    }
  }

  name = each.key

  tags = each.value
}

output "for_each_map_user_arns" {
  value = values(aws_iam_user.for_each_map).*.arn
}
```   
![image](https://user-images.githubusercontent.com/43658658/156278000-cc680625-b9cf-4c7a-b2d3-8c69dfdd51ad.png)   
![image](https://user-images.githubusercontent.com/43658658/156278018-248ec2c3-72cd-49f9-8cea-49c3f4bad39f.png)



