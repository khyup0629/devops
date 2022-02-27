# Resource와 Data 블럭

=> [테라폼 공식 문서 EC2_instance 참고](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)

```
cd
mkdir 03-resource
cd 03-resource
vim main.tf
```

#### < main.tf >

```
provider "aws" {
  # Configuration options
  region = "ap-northeast-2"
}

resource "aws_instance" "ubuntu" {
  ami           = "ami-0454bb2fefc7de534"
  instance_type = "t2.micro"

  tags = {
    Name = "test-ubuntu"
  }
}

```   
- `resource <block label 1> <block label 2>`
  * `<block label 1>` : 리소스의 종류
  * `<block label 2>` : 리소스의 이름
- `ami` : 인스턴스를 시작할 때 우분투 프리티어의 ami id를 작성합니다.   
![image](https://user-images.githubusercontent.com/43658658/155877969-1c28a9dc-5c98-4550-beda-27dd0648ce4a.png)

- `instance_type` : 인스턴스의 클래스를 나타내고, 프리티어인 `t2.micro`를 작성합니다.
- 그 밖에 쓰이는 `Argument`에 대해 알고 싶다면, 공식 문서 페이지의 아래 부분의 `Argument Reference`를 참고합니다.   
![image](https://user-images.githubusercontent.com/43658658/155878030-dbe4a3e3-9f13-4980-b5b7-6795a54ef8d2.png)

provider인 aws가 새로 생성되었으므로 테라폼을 초기화하고 적용합니다.   
```
tf init
tf apply
```


