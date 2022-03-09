# Window 테라폼 설치

해당 사이트로 접속해 **최신 버전의 테라폼을 다운** 받습니다.   
=> [테라폼 설치 사이트](https://www.terraform.io/downloads)

파일의 압축을 풀고 해당 경로에 `terraform.exe` 파일을 위치시킵니다.   
![image](https://user-images.githubusercontent.com/43658658/157378142-7464598c-1f94-4e12-82eb-1826a38c2a78.png)

`제어판 > 시스템 및 보안 > 고급 시스템 설정 > 고급 > 환경 변수'에서 해당 내용의 **환경 변수**를 지정합니다.   
![image](https://user-images.githubusercontent.com/43658658/157378423-1ce0d345-9fc2-4ac3-bc29-c4a01aaba1e0.png)

`cmd`를 열고 `terraform`을 입력해서 정상적으로 설치 되었는지 확인합니다.   
![image](https://user-images.githubusercontent.com/43658658/157379024-6672dfc5-12e2-46e5-9399-253d599d6cdd.png)

# AWS CLI 설치 및 계정 연동

아래 링크를 눌러 **AWS CLI 최신 버전**을 설치합니다.   
=> [AWS CLI 최신 버전 다운로드](https://awscli.amazonaws.com/AWSCLIV2.msi)

`AWS 계정으로 접속 > IAM > 보안 자격 증명 > 액세스 키`에서 계정에 대한 **액세스 키**와 **시크릿 액세스 키**를 확인합니다.

`cmd`를 열고 `aws configrue` 명령을 입력해 **액세스 키 값**을 입력합니다.
```
aws configure
```

제대로 연동되었는지 확인합니다.   
```
aws sts get-caller-identity
```   
![image](https://user-images.githubusercontent.com/43658658/157378934-8cf70037-9ada-40e3-8edb-12e44d0f1f85.png)

