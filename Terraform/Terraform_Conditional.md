# 조건문(Conditional)

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
