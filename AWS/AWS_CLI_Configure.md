# AWS Configure

`AWS CLI`를 설치하고 진행되어야 하는 과정입니다.   
=> [AWS CLI 설치 과정](https://github.com/khyup0629/devops/blob/main/AWS/AWS_CLI_Installation_In_Ubuntu.md#aws-cli-%EC%84%A4%EC%B9%98ubuntu)

## 명령어로 등록하기

명령어를 통해 액세스 키, 시크릿 액세스 키, 리전, 출력 형식을 설정할 수 있습니다.   
```
aws configure
```

## Config 파일에 등록하기

`AWS CLI`를 정상적으로 설치했다면, `~/.aws/config` 파일일 존재할 것입니다.   

```
vim ~/.aws/config
```

- `aws_access_key_id` : 액세스 키
- `aws_secret_access_key` : 시크릿 액세스 키
- `region` : 리전
- `output` : 출력 형식. json, text, table, yaml, yaml-stream 형식이 존재합니다.   
```
[default]
aws_access_key_id=AKIA3TM7R3RLLGIJ4M4O
aws_secret_access_key=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
region = ap-northeast-2
output = json
```
