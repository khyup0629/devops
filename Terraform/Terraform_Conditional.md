# 조건문(Conditional Expresssion)

`is_john`이라는 변수의 `true` 또는 `false`에 따라 출력되는 값이 달라지는 코드에 대해 조건문을 이용해보겠습니다.   
``` terraform
provider "aws" {
  region = "ap-northeast-2"
}

variable "is_john" {
  type = bool
  default = true
}

locals {
  message = var.is_john ? "Hello John!" : "Hello!"
}

output "message" {
  value = local.message
}
```

디폴트 값이 `true`이므로 `Hello John!`이 출력됩니다.   
```
tf apply
```   
![image](https://user-images.githubusercontent.com/43658658/156304828-9db19547-6e9c-4bc2-8c54-434ac53bf5e9.png)

`is_john` 변수의 값을 `false`로 한 뒤 출력하면, `Hello!`가 출력됩니다.   
```
tf apply -var="is_john=false"
```   
![image](https://user-images.githubusercontent.com/43658658/156304879-a74f8f74-ce33-4b9c-a958-c2560e2ed23a.png)

## 특정 조건을 만족하면 리소스 생성/삭제

특정 조건을 만족할 때 리소스를 생성 또는 삭제하는 트릭을 배워보겠습니다.

- `internet_gateway_enabled` 라는 변수가 true이면 `aws_internet_gateway`의 `count = 1`이 되어 인터넷 게이트웨이가 생성됩니다.
- 반대로 `false`이면 `aws_internet_gateway`의 `count = 0`이 되어 인터넷 게이트웨이가 삭제됩니다.   
``` terraform
# main.tf
provider "aws" {
  region = "ap-northeast-2"
}

variable "internet_gateway_enabled" {
  type = bool
  default = true
  description = "true : 인터넷 게이트웨이 생성, false : 인터넷 게이트웨이 삭제"
}

resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "this" {
  count = var.internet_gateway_enabled ? 1 : 0
  
  vpc_id = aws_vpc.this.id
}
```   

디폴트 값은 `true`이므로 인터넷 게이트웨이가 생성됩니다.   
```
tf apply
```   
![image](https://user-images.githubusercontent.com/43658658/156306766-0cf5a148-a11c-423f-902c-40491fed45d0.png)

변수를 `false`로 바꿔주면 인터넷 게이트웨이가 삭제됩니다.   
```
tf apply -var="internet_gateway_enabled=false"
```   
![image](https://user-images.githubusercontent.com/43658658/156306938-ef5d89db-44d1-4290-bf04-78baffe189bc.png)


