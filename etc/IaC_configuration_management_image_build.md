# IaC (Infrastructure as Code)

네트워크, 로드밸런서, 저장소, 서버 등의 **인프라 자원**을 수동 설정이 아닌 **코드를 이용**하여 **프로비저닝하고 관리**하는 것

ex) **Terraform**, CloudFormation, Pulumi, Azure ARM Template

## 선언형 설정

**선언적**으로 정의.

```
서버 이름 : ~
서버 클래스 : ~

(...)
```

# 형상 관리 (Configuration Management)

서버 운영체제 상에 **필요한 소프트웨어를 설치**하고 **원하는 설정으로 관리**하는 것을 **코드를 이용**하는 것.   
= Configuration as Code   

ex) **Ansible**, Puppet, Chef, Salt Stack

## 절차형 설정

**순차적**으로 명령어를 수행.

```
1. 패키지 업데이트
2. nginx 설치
3. 방화벽 설정
```

# 이미지 빌더 도구

AWS EC2의 AMI 같은 **이미지를 빌드할 수 있는 도구**입니다.

ex) **packer**, AWS EC2 Image Builder(AMI)



