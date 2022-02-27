# HCL 기초 문법

## Block과 Argument

```
resource "aws_vpc" "main" {
  cidr_block = var.base_cidr_block
}

<BLOCK TYPE> "<BLOCK LABEL>" "<BLOCK LABEL>" {
  # Block body
  <IDENTIFIER> = <EXPRESSION> # Argument
}
```

## 파일과 디렉토리

> <h3>파일의 형식</h3>

파일의 형식은 두 가지가 있습니다.   
- `.tf` : HCL 형식, 웬만하면 이 확장자를 이용하는 것이 좋습니다. json은 상대적으로 비효율적인 형식입니다.
- `.tf.json` : json 형식

> <h3>현재 디렉토리만 실행</h3>

워크플로(write/plan/apply)를 진행할 때 현재 디렉토리의 `.tf` 또는 `.tf.json` 파일을 찾아서 실행합니다.   
(하위 디렉토리는 실행하지 않습니다)   
```
[Directory]
 ㄴ a.tf     # 얘는 인식
 ㄴ [Sub Directory]
     ㄴ b.tf    # 얘는 인식 못해요.
```

> <h3>파일 인코딩</h3>

파일 인코딩의 경우 `UTF-8`을 이용해야 합니다.   

개행문자의 경우    
- `Unix` : LF
- `Windows` : CRLF

로 서로 달라서 다른 한쪽으로 옮겨갈 때 파일이 깨지는 경우가 있는데,   
`Terraform`은 둘 모두를 지원합니다.   

하지만, `LF` 방식의 개행문자를 더 선호합니다.

> <h3>모듈</h3>

`.tf` 파일을 가지고 있는 디렉토리를 모듈이라 부릅니다.

- `root module` : 현재 테라폼을 실행하는 모듈.
- `child module` : 현재 실행하는 모듈이 사용하는 다른 모듈.

만약 c 모듈에서 테라폼을 실행하고, c 모듈이 a, b 모듈을 이용한다면,   
```
[Directory]
 ㄴ [a]  # child
 ㄴ [b]  # child
 ㄴ [c]  # root
```

## Syntax

> <h3>식별자 인식</h3>

테라폼에서는 다음과 같은 문자로 이루어진 식별자(블럭이름, 아규먼트 이름 등)를 인식합니다.   
- 대소문자
- 숫자
- `-`
- `_`

또한 식별자의 첫 번째 문자가 숫자이면 안됩니다.

> <h3>주석</h3>

- `#` : 한 줄 주석
- `//` : 한 줄 주석
- `/*` and `*/` : 여러 줄 주석

> <h3>Style Conventions</h3>

테라폼에서 지향하고 있는 코딩 규약을 의미합니다.

협업이 원활해지고, 훨씬 깔끔한 작성이 가능해집니다.

#### <코드 예시>

```
resource "aws_instance" "example" {
  count = 2 # meta-argument first

  ami           = "abc123"
  instance_type = "t2.micro"

  network_interface {
    # ...
  }

  lifecycle { # meta-argument block last
    create_before_destroy = true
  }
}
```

- **tab**이 아닌 `two spaces(두 칸 공백)`를 이용합니다.
- key-value를 기록할 때는 되도록 **공백을 맞춰서 깔끔하게 작성**합니다.
- key-value의 길이가 들쑥날쑥할 경우 **한 줄 띄우기를 기준으로 논리적인 그룹**으로 나눕니다.
- 머리 부분과 꼬리 부분에 위치하는 `meta-argument`가 나뉩니다.
  * **머리 부분** : `count`, `for_each`
  * **꼬리 부분** : `lifecycle`, `depends_on`

테라폼에서는 **Style Conventions**에 맞도록 코드를 포맷해주는 명령어가 존재합니다.   
```
tf fmt -diff
```   
- `-diff` : 변경사항에 대해 로그를 보여줍니다.














