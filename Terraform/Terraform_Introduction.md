# 테라폼 소개

## 테라폼 워크플로

Write, Plan, Apply 방식

> <h3>1. Write</h3>   

- `HCL`을 활용한 선언적 **설정 파일**을 생성합니다.   
![image](https://user-images.githubusercontent.com/43658658/155824888-cb7d222d-b012-4198-95b0-e2eb1b74d394.png)   


> <h3>2. Plan</h3>   

- `terraform plan`을 실행해서 인프라를 생성하기 전 기존 인프라와 비교해 변경된 점, 설정 구성을 체크합니다.   
![image](https://user-images.githubusercontent.com/43658658/155824952-de00dfff-0e39-4708-822e-42d7e66047a7.png)   
![image](https://user-images.githubusercontent.com/43658658/155824990-98c02aa8-b75f-4506-840e-2794a67d94d2.png)

> <h3>3. Apply</h3>   

- `terraform apply`를 통해 provider에 **설정 파일을 적용**합니다.   
![image](https://user-images.githubusercontent.com/43658658/155825003-06e75ce4-b911-4b60-8ec9-4df649962454.png)   

## 레지스트리

`레지스트리`는 테라폼을 이용하면서 사용할 **provider**와 **module**을 찾을 수 있는 곳입니다.   
![image](https://user-images.githubusercontent.com/43658658/155825040-f466c141-175f-4338-bd47-9dbe12d59414.png)

- Provider : AWS, GCP, Azure와 같은 인프라 환경
- Module : 인프라 리소스 그룹 템플릿(Instance + Security Group + EBS)   
![image](https://user-images.githubusercontent.com/43658658/155825045-2eb8edff-efcc-48cc-a420-ebdf49fd1e1c.png)   
