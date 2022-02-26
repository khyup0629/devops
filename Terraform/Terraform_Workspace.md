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

