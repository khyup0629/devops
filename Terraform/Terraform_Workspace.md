# 테라폼 워크스페이스

- Workspace : 프로젝트 단위

프로젝트의 규모가 작다면 통째로 관리할 수 있지만,   
규모가 커질 수록, 프로젝트도 커져, 프로젝트를 나누는 작업이 필요해집니다.   
- infra : Network, account, domain, service-a, service-b ...

## 워크스페이스 생성

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

