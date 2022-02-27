# 테라폼 워크스페이스

- Workspace : 프로젝트 단위

프로젝트의 규모가 작다면 통째로 관리할 수 있지만,   
규모가 커질 수록, 프로젝트도 커져, 프로젝트를 나누는 작업이 필요해집니다.   
- infra : Network, account, domain, service-a, service-b ...

## 워크스페이스 생성

> <h3>1. Write</h3>

```
mkdir 01-start
cd 01-start
vim main.tf
```

먼저 사용할 Provider를 선택해야 합니다.   
=> [실습을 위한 Local Provider](https://registry.terraform.io/providers/hashicorp/local/latest)   
![image](https://user-images.githubusercontent.com/43658658/155827060-5c42edca-df4a-4731-8c2a-b530f9337fb2.png)

`Documentation > Use Provider`로 접근하면 Provider를 사용하는 방법을 볼 수 있습니다.   
- `terraform`과 `provider`라는 두 개의 섹션으로 나뉘어집니다.
- `terraform`에서 `version`은 명시하지 않아도 됩니다. 버전을 명시하지 않으면 `최신 버전`으로 자동 설정됩니다.
- 저희는 `version`이 필요 없으니 `provider` 섹션만 이용하겠습니다.

![image](https://user-images.githubusercontent.com/43658658/155827134-4048daa8-d42e-42ad-bfd6-dd3a1e9f3cd0.png)  

```
# main.tf
provider "local" {
  
}
```

`local provider`는 지정한 내용으로 `local_file`을 생성할 수 있도록 해주는 provider입니다.

`local_file`을 생성해보겠습니다.   
- `Documentation`의 사이드바를 보면 local provider에서 사용할 수 있는 리소스와 데이터 소스의 사용 방법을 볼 수 있습니다.

![image](https://user-images.githubusercontent.com/43658658/155827285-2d9eb01b-d931-4a23-97cf-a2068b7732c3.png)

* 해당 내용을 복붙합니다.   

![image](https://user-images.githubusercontent.com/43658658/155827495-0b58a5fb-428f-40e7-8ada-e4b8c8c76629.png)   
- `${<테라폼 함수>}` : 문자열 내에서 테라폼 함수에 대한 결과값을 이용하고 싶을 때 이용합니다.
- `path.module` : 현재 `main.tf` 파일의 위치를 나타냅니다.

```
# main.tf
provider "local" {
  
}
resource "local_file" "foo" {
    filename = "${path.module}/foo.txt"
    content  = "Hello World!"
}
```

파일 내용을 저장하고, 테라폼을 실행합니다.   
```
terraform init
```   
![image](https://user-images.githubusercontent.com/43658658/155827722-730a37f3-4603-49e1-a101-7e7271961c58.png)

현재 디렉토리를 살펴보면 `main.tf` 말고도 `.terraform` 디렉토리와 `.terraform.lock.hcl` 파일이 생성되었음을 확인할 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/155827774-3f6ff43f-2927-45ea-a221-d554fd86c5b1.png)

`.terraform` 폴더에는 현재 워크스페이스의 provider, module이 설치됩니다.   
![image](https://user-images.githubusercontent.com/43658658/155827801-c8793eeb-7f34-4b24-b7b9-5416ee0db4ae.png)

`.terraform.lock.hcl` 파일에는 **CI/CD 파이프라인 구성**에 필요한 정보가 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/155827836-cf77ff19-087b-4412-81c2-c9819712a31c.png)

(꿀팁)`alias` 지정을 통해 `terraform` 명령어를 줄여서 사용합시다.   
```
alias tf=terraform
```

> <h3>2. Plan</h3>

**Apply**하기 전 변경 사항을 체크합니다.   
```
tf plan
```   
![image](https://user-images.githubusercontent.com/43658658/155827909-a8877db1-f741-4914-b84b-698d33a7e86f.png)

> <h3>3. Apply</h3>

변경사항을 적용합니다.   
```
tf apply
```   
![image](https://user-images.githubusercontent.com/43658658/155828007-4373fda1-fc1e-446d-9273-c569f0d058d1.png)

현재 디렉토리에 `foo.txt` 파일이 생성된 것을 확인할 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/155828047-deb3f7af-6115-4b7e-acfe-90eafbaaacdc.png)   
![image](https://user-images.githubusercontent.com/43658658/155828058-060da429-21f9-42bd-8686-a84e3f50adc5.png)

그 밖에도 `.terraform.tfstate` 파일이 생성된 것을 볼 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/155828090-5a1ff1d9-8b74-4b2f-8d24-93ac82013eb5.png)

이 파일에는 현재 리소스에 대한 정보가 JSON 형식으로 저장되어 있습니다.   
- 이 파일을 기준으로 나중에 main.tf를 변경할 때 변경사항을 체크합니다.   

![image](https://user-images.githubusercontent.com/43658658/155828101-1f1d871c-db24-412c-8c6c-8efbd873edc0.png)

> <h3>Data source 사용하기</h3>

local provider의 data source를 사용해보겠습니다.   
![image](https://user-images.githubusercontent.com/43658658/155828305-60a8a361-8471-4442-9928-259f98eaa463.png)

`main.tf`의 아래에 다음의 내용을 추가합니다.   
```
# main.tf
provider "local" {
  
}
resource "local_file" "foo" {
    filename = "${path.module}/foo.txt"
    content  = "Hello World!"
}
data "local_file" "bar" {
    filename = "${path.module}/bar.txt"
}
output "file_bar" {
    value = data.local_file.bar
}
```

`bar.txt` 파일을 읽기 위해선 파일이 존재해야겠죠.   
```
cat > bar.txt
Hello World!
```

변경사항을 적용합니다.   
```
tf apply
```   
![image](https://user-images.githubusercontent.com/43658658/155828479-206a15b4-3e6c-4ab2-b504-74ce077be1f6.png)   
- `main.tf`의 `data` 섹션이 `bar.txt` 파일을 읽어들입니다.
- `output` 섹션이 `file_bar`라는 이름의 Object를 생성하여 `bar.txt` 파일의 내용을 출력합니다.

> <h3>AWS provider 사용하기</h3>

AWS provider를 이용하기 위해서는 `AWS CLI Credential` 설정을 먼저 진행해주어야 합니다.   
=> [AWS CLI Credential 설정]()

위 자격증명 설정을 진행하셨다면 아래의 Docs를 참고하며 실습을 진행합니다.   
=> [AWS provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

해당 내용을 `main.tf` 파일에 추가합니다.   
![image](https://user-images.githubusercontent.com/43658658/155828618-0561a022-fc26-4cf8-9fb2-3b45d191f88e.png)

```
# main.tf
provider "local" {

}

# Configure the AWS Provider
provider "aws" {
  region = "ap-northeast-2"
}

resource "local_file" "foo" {
    filename = "${path.module}/foo.txt"
    content  = "Hello World!"
}

data "local_file" "bar" {
    filename = "${path.module}/bar.txt"
}

output "file_bar" {
    value = data.local_file.bar
}

# Create a VPC
resource "aws_vpc" "foo" {
  cidr_block = "10.0.0.0/16"
}
```

`aws`라는 **새로운 provider**를 추가했기 때문에 `terraform init`을 실행합니다.   
```
tf init
```

다음으로 apply하기 전 변경 사항을 알아봅니다.   
```
tf plan
```   
![image](https://user-images.githubusercontent.com/43658658/155871323-c11b92c3-3e76-4e94-bdef-0e4b98c6163f.png)

마지막으로 적용합니다.   
```
tf apply
```

**AWS 콘솔**의 `VPC`로 접근해보면 `CIDR 10.0.0.0/16`인 VPC가 생성된 것을 확인할 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/155871385-29932100-00c6-49c9-b58d-6706e176067a.png)

생성한 VPC의 출력값을 보겠습니다.   

```
vim main.tf
```

```
provider "local" {

}

# Configure the AWS Provider
provider "aws" {
  region = "ap-northeast-2"
}

resource "local_file" "foo" {
    filename = "${path.module}/foo.txt"
    content  = "Hello World!"
}

data "local_file" "bar" {
    filename = "${path.module}/bar.txt"
}

output "file_bar" {
    value = data.local_file.bar
}

# Create a VPC
resource "aws_vpc" "foo" {
  cidr_block = "10.0.0.0/16"
}


output "vpc_foo" {
    value = aws_vpc.foo
}
```   
- `resource`의 경우 `output`을 추가할 때 `value`를 `resource` 뒤의 파라미터(aws_vpc, foo)를 .으로 연결시켜주면 됩니다(`aws_vpc.foo`)

apply를 하면 `vpc_foo`라는 이름의 **output이 추가**된 것을 확인할 수 있습니다.   
```
tf apply
```   
![image](https://user-images.githubusercontent.com/43658658/155872960-0946fcb8-7744-47c7-9b3b-9bd5ba7bc03f.png)   
- vpc에 대한 정보를 보여줍니다.

> <h3>리소스 변경하기</h3>

기존에 aws에 생성한 `VPC`에 태그 네임을 추가해보겠습니다.

```
vim main.tf
```

```
provider "local" {

}

# Configure the AWS Provider
provider "aws" {
  region = "ap-northeast-2"
}

resource "local_file" "foo" {
    filename = "${path.module}/foo.txt"
    content  = "Hello World!"
}

data "local_file" "bar" {
    filename = "${path.module}/bar.txt"
}

output "file_bar" {
    value = data.local_file.bar
}

# Create a VPC
resource "aws_vpc" "foo" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "Name" = "This is test vpc"
  }
}


output "vpc_foo" {
    value = aws_vpc.foo
}
```

apply를 통해 적용합니다.   
```
tf apply
```   
![image](https://user-images.githubusercontent.com/43658658/155873280-a27eb95c-9648-4fb3-a841-a0b3cce48327.png)   
- Tags 값의 경우 변경 사항으로 적용합니다.

**AWS 콘솔**로 접근해 살펴보면 이름이 추가된 것을 확인할 수 있고, [태그]탭에도 `Name` 키가 추가된 것을 확인할 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/155873159-2229cc4d-4587-4378-97a8-04c510523805.png)   
![image](https://user-images.githubusercontent.com/43658658/155873168-d734ade8-70b1-4798-8a51-96c4735b0a57.png)

이번엔 `CIDR`의 값을 변경해보겠습니다.   

```
vim main.tf
```

```
provider "local" {

}

# Configure the AWS Provider
provider "aws" {
  region = "ap-northeast-2"
}

resource "local_file" "foo" {
    filename = "${path.module}/foo.txt"
    content  = "Hello World!"
}

data "local_file" "bar" {
    filename = "${path.module}/bar.txt"
}

output "file_bar" {
    value = data.local_file.bar
}

# Create a VPC
resource "aws_vpc" "foo" {
  cidr_block = "10.123.0.0/16"

  tags = {
    "Name" = "This is test vpc"
  }
}


output "vpc_foo" {
    value = aws_vpc.foo
}
```

적용합니다.   
```
tf apply
```   

분명 `CIDR` 값을 변경했는데, 태그값을 추가한 것과는 다르게 리소스를 삭제(destroy)했다가 다시 추가(add)합니다.
![image](https://user-images.githubusercontent.com/43658658/155873356-381536b8-d814-4ecc-abc9-27357b359aa0.png)   

AWS VPC는 이미 생성한 VPC의 **CIDR 변경을 지원하지 않습니다.**   
그렇기 때문에 CIDR 값을 변경하려하면, **기존 리소스를 지우고 새로운 리소스를 생성**하려 하는 것입니다.

> <h3>리소스를 변경할 때 주의사항</h3>

위의 예제에서 보았듯, `Terraform`은 **리소스의 인자값**이 AWS에서 변경 가능한지 아닌지 인지하고 있습니다.

`tf apply`에서 `yes`를 입력하기 전 항상 인자값의 변경에 대해 이처럼 변경(`Changed`)하는 것인지, 삭제하고 추가(`Destroy` and `Add`)하는 것인지 체크해야합니다.

**삭제하고 추가하는 경우, 기존의 리소스를 지우는 행위를 진행하기 때문에 서비스에 치명적인 영향을 미칠 수 있습니다.**



