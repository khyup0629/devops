# Terraform Runner

테라폼 클라우드에서 워크스페이스를 선택하고 `Settings > General`로 접근하면 `Execution Mode(실행모드)`가 있습니다.

이 실행모드를 `Remote`로 선택하게 되면 `Terraform Runner`를 이용할 수 있습니다.

다음으로 `Terraform Working Directory`를 입력합니다.   
![image](https://user-images.githubusercontent.com/43658658/156549308-7da2456f-f2d2-4a87-8802-bf76f85aec11.png)

`Working Directory`는 리포지토리 밑의 경로입니다.   
![image](https://user-images.githubusercontent.com/43658658/156549697-63136f0a-7151-4bc0-b98d-d04b7b9f3c1a.png)

## AWS Provider와 연동하기

워크스페이스의 `variable` 탭으로 접근해서 `Add variable` 버튼을 클릭합니다.
![image](https://user-images.githubusercontent.com/43658658/156547268-ec632244-2406-4a0c-b5bd-e8cda0838246.png)

`환경 변수`를 선택하고, AWS 계정의 **액세스 키**와 **시크릿 액세스 키**를 생성합니다.   
(`Sensitive`를 체크합니다)   
![image](https://user-images.githubusercontent.com/43658658/156547669-c5337f29-0836-453e-b5db-aef6b3660a1c.png)   
![image](https://user-images.githubusercontent.com/43658658/156547904-3d490fbc-5164-4994-b2aa-1fb368e2aafe.png)

AWS 계정의 **액세스 키**와 **시크릿 액세스 키**를 환경 변수로 등록하면, 로컬에서 `apply`시 해당 테라폼 클라우드 워크스페이스를 참조할 수 있습니다.

## terraform.tfvars 변수 추가

다음으로 `terraform.tfvars`의 내용을 추가합니다.   
![image](https://user-images.githubusercontent.com/43658658/156548376-c75861c8-9ceb-4785-b159-7ed412418e72.png)   
``` terraform
[
  {
    name = "john"
    level = 7
    role = "재무"
    is_developer = false
  },
  {
    name = "alice"
    level = 1
    role = "인턴 개발자"
    is_developer = true
  },
  {
    name = "tony"
    level = 4
    role = "데브옵스"
    is_developer = true
  },
  {
    name = "cindy"
    level = 9
    role = "경영"
    is_developer = false
  },
  {
    name = "hoon"
    level = 3
    role = "마케팅"
    is_developer = false
  },
]
```

`terraform.tfvars`의 내용을 추가하면 로컬에서 `apply`시 해당 내용을 참조하게 됩니다.

## 테스트

테스트를 진행하기 위해 로컬로 돌아와 `apply`를 해봅시다.   
```
tf apply
```   

정상적으로 실행되는 것을 볼 수 있습니다.   
(로컬에서 실행하는 것에 비해서 `app.terraform.io`를 참조해야 하기 때문에 오래걸립니다)   
![image](https://user-images.githubusercontent.com/43658658/156549989-598723fa-393f-4694-8eee-e3f84500def8.png)

`Run` 탭에서 해당 코드의 실행 현황을 알 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/156550790-89d44cd6-6067-4dbd-9b34-daa1ad919f04.png)
