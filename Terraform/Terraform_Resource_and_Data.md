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

`AWS 콘솔`의 `EC2`로 접근하면 `test-ubuntu`라는 이름의 서버가 하나 생성된 것을 확인할 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/155910272-695d9b93-5a01-4724-9387-6c8beffde5e9.png)

data 소스를 사용해보겠습니다.   

아래의 소스 코드는 우분투 ami의 가장 최신 버전을 가져오는 코드입니다.   
```
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
```   
- `most_recent` : 가장 최신 ami를 가져오겠다.
- `filter` : 필터링 기능을 합니다.
- `owners` : `Canonical`(우분투를 만든 회사)의 ami만 가져오겠다.

이 데이터 블럭을 `main.tf`에 추가하고, 리소스 블럭에서 ami 아규먼트의 값을 아래와 같이 참조하도록 변경합니다.   
```
provider "aws" {
  # Configuration options
  region = "ap-northeast-2"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "ubuntu" {
  ami           = data.aws_ami.ubuntu.image_id   # data 블럭에서 image id를 조회
  instance_type = "t2.micro"

  tags = {
    Name = "test-ubuntu"
  }
}
```   
- **data 블럭을 조회하는 방법**은 [공식 문서](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami)의 Reference를 참조하세요.

적용합니다.   
```
tf apply
```

기존에 생성한 인스턴스의 ami가 최신버전이 아니었기에 최신 버전의 ami로 서버를 새로 시작한다는 것을 확인할 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/155911285-64ab8991-e751-48c4-af2c-6d87ea72a0cb.png)

`AWS 콘솔`을 확인해보면 아래와 같이 기존 서버는 종료되고 새로운 서버가 생성됩니다.   
![image](https://user-images.githubusercontent.com/43658658/155911403-2bc893ac-a016-4bda-8d25-5535ca95ca3d.png)

비용을 절약하기 위해 생성한 인스턴스를 모두 종료합니다.   
```
tf destroy
```





