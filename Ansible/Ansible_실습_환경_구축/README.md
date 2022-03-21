# Ansible 실습 환경 구축

실습 환경 구축을 위해 AWS를 이용하고, `Network` 폴더와 `ec2-instance` 폴더로 나눠 **terraform 코드**로 인프라를 구축했습니다.   

사전에 **AWS CLI** 자격증명 등록(`aws configure`) 및 **Terraform Cloud** 연동(`Token 등록`)이 완료되어 있어야 합니다.

## Network 폴더 구조

![image](https://user-images.githubusercontent.com/43658658/159259411-f58ab09a-2c2c-4bc6-8811-9f8031fa731c.png)

- `terraform.tf` 파일에서 `remote backend` 설정을 진행합니다.
  - `organization`과 `workspace`의 이름을 각각 넣어야합니다.

## ec2-instance 폴더 구조

![image](https://user-images.githubusercontent.com/43658658/159259514-1bbacf36-3eb2-4b61-b34e-f47d2e6152b5.png)

- `config.yaml` 파일에서 `remote backend` 설정을 진행합니다.
  - `organization`과 `workspace`의 이름을 각각 넣어야합니다.
