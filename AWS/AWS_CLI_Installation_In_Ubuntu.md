# AWS CLI 설치(ubuntu)

=> [AWS CLI 설치 방법(AWS 공식 문서)](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

먼저 `AWS CLI`를 설치하기 전 사전 작업을 진행합니다.   
```
sudo apt update
sudo apt install -y unzip build-essential curl
```

본격적으로 `AWS CLI`를 설치합니다.   
```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.2.16.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```   
- `curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"` : 버전을 입력하지 않으면 자동으로 최신 버전의 zip 파일을 설치합니다.

설치가 끝나면 `AWS CLI`가 잘 설치되었는지 확인합니다.   
```
aws --version
```   
![image](https://user-images.githubusercontent.com/43658658/155829258-5de70fb7-b986-43da-99ba-f9d1de5ad266.png)

