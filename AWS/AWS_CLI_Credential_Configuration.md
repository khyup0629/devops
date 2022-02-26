# AWS CLI를 통한 자격증명 Config

이번에는 `AWS CLI`를 통해 AWS 계정의 자격증명을 진행하는 방법을 알아보겠습니다.

먼저 이번 과정을 수행하기 위해서는 `AWS CLI`가 설치되어 있어야 합니다.   
=> [AWS CLI 설치 과정(ubuntu)](https://github.com/khyup0629/devops/blob/main/AWS/AWS_CLI_Installation_In_Ubuntu.md#aws-cli-%EC%84%A4%EC%B9%98ubuntu)

> <h3>AWS CLI 자격증명 우선순위</h3>

**CLI 명령어 옵션**   
**환경변수**   
CLI 자격증명 파일 - `~/.aws/credentials`   
**CLI 설정 파일** - `~/.aws/config`   
컨테이너 자격증명(ECS의 경우)   
**인스턴스 프로파일 자격증명(EC2의 경우)**   

> <h3>자격증명 Config</h3>

먼저 AWS 계정으로 접속하고, `보안 자격 증명`으로 접근합니다.   
![image](https://user-images.githubusercontent.com/43658658/155829837-fecd5847-5346-4d67-a50c-ea5ffa98f956.png)

**액세스 키**를 생성하고 키 파일을 다운로드 합니다.   
![image](https://user-images.githubusercontent.com/43658658/155829858-929870ad-a8a4-4ef0-9664-9fca434b31f7.png)

