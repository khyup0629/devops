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





