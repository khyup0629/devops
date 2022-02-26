# 테라폼 소개

## 테라폼 워크플로

Write, Plan, Apply 방식

> <h3>1. Write</h3>   

- `HCL`을 활용한 선언적 **설정 파일**을 생성합니다.   
![image](https://user-images.githubusercontent.com/43658658/155824888-cb7d222d-b012-4198-95b0-e2eb1b74d394.png)   

> <h3>2. Plan</h3>   

- `terraform plan`을 실행해서 **Apply**하기 전 기존 인프라와 비교해 변경된 점, 설정 구성을 체크합니다.   
![image](https://user-images.githubusercontent.com/43658658/155824952-de00dfff-0e39-4708-822e-42d7e66047a7.png)   
![image](https://user-images.githubusercontent.com/43658658/155824990-98c02aa8-b75f-4506-840e-2794a67d94d2.png)

> <h3>3. Apply</h3>   

- `terraform apply`를 통해 provider에 **설정 파일을 적용**합니다.   
![image](https://user-images.githubusercontent.com/43658658/155825003-06e75ce4-b911-4b60-8ec9-4df649962454.png)   

## 레지스트리

`레지스트리`는 테라폼을 이용하면서 사용할 **provider**와 **module**을 찾을 수 있는 곳입니다.   
![image](https://user-images.githubusercontent.com/43658658/155825040-f466c141-175f-4338-bd47-9dbe12d59414.png)

- Provider : AWS, GCP, Azure, k8s와 같은 인프라 환경
- Module : 인프라 리소스 그룹 템플릿(Instance + Security Group + EBS)   
![image](https://user-images.githubusercontent.com/43658658/155825045-2eb8edff-efcc-48cc-a420-ebdf49fd1e1c.png)   

> <h3>Provider</h3>

**Provider**로 접근해봅시다.   
![image](https://user-images.githubusercontent.com/43658658/155825734-1c843822-0606-489f-884a-49cfb3167002.png)

`AWS`를 클릭합니다.   
![image](https://user-images.githubusercontent.com/43658658/155825526-00c67533-4c1a-4781-9ffc-690dc02f84d0.png)

소스 코드의 링크를 통해 깃허브 리포지토리로 접속할 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/155825575-a37c771c-29c2-44fe-aae5-b65c3f1e61b1.png)

`Documentation`을 통해 해당 Provider를 어떻게 사용하는지, Provider가 제공하는 리소스의 사용 방법에 대한 문서를 볼 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/155825604-f42a4ce2-cbc5-43b3-a07f-d68fe22f8627.png)

> <h3>Module</h3>

다음으로, **Module**로 접근해봅시다.   
![image](https://user-images.githubusercontent.com/43658658/155825745-9383c315-2f56-4feb-aac5-463c09811f28.png)

사용할 수 있는 Module의 리스트를 볼 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/155825753-8c6e9035-f1f2-41db-b2f1-da46b3c05429.png)

Module 중 하나를 클릭해 접속해보면 여러 탭들을 확인할 수 있습니다.   
- `Readme` : 해당 모듈을 사용하는 방법.
- `Input` : 해당 모듈에서 사용할 수 있는 인자값에 대한 설명.
- `Output` : 해당 모듈을 사용할 때의 출력값에 대한 설명.
- `Dependancy` : 해당 모듈을 사용하기 위한 의존성 Provider.
- `Resources` : 해당 모듈에서 사용 가능한 리소스.

![image](https://user-images.githubusercontent.com/43658658/155825888-0adaf0c5-8f09-4479-9d5c-555a8c3f76f4.png)

## Docs

테라폼의 공식 문서들이 모여있는 곳입니다.   
![image](https://user-images.githubusercontent.com/43658658/155826302-67cf8815-6212-4225-bfc9-e52062874ad6.png)

테라폼을 이용하면서 많이 참고해야 할 부분입니다.
