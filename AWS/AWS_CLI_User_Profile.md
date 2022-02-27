# AWS CLI 사용자 프로파일

## 멀티 사용자 프로파일 예제

1. 여러 AWS 계정 운영
2. 동일 계정 내 여러 리전 운영
3. 동일 계정 내 여러 IAM 역할 전환 수행
4. AWS SSO 조직 내 SSO 역할 수행

#### < ~/.aws/config >

사용자 프로파일을 두 개 생성합니다.   
```
# ~/.aws/config
[default]
aws_access_key_id=AKIA3TM7R3RLLGIJ4M4O
aws_secret_access_key=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
region = ap-northeast-2
output = yaml

[profile eu-west-1]
aws_access_key_id=AKIA3TM7R3RLLGIJ4M4O
aws_secret_access_key=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
region = eu-west-1

[profile ap-northeast-1]
aws_access_key_id=AKIA3TM7R3RLLGIJ4M4O
aws_secret_access_key=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
region = ap-northeast-1
```   
- 액세스 키, 시크릿 액세스 키는 모두 동일한 상태에서 리전만 다른 **사용자 프로파일**을 생성합니다.

`get region` 명령어는 프로파일의 리전 정보를 출력합니다.   
```
hyeob@hyeob:~/01-start$ aws configure get region
ap-northeast-2
```   
- 디폴트값인 `ap-northeast-2`를 출력합니다.

`--profile <프로파일 이름>` 옵션을 추가하면 해당 프로파일에 대한 리전값이 출력됩니다.   
```
hyeob@hyeob:~/01-start$ aws configure get region --profile eu-west-1
eu-west-1
```

현재 프로파일을 **환경변수**로 직접 `export`로 정의해주면 `config` 파일에 설정된 내용보다 **환경변수**가 우선순위로 적용되어 `ap-northeast-1`이 출력됩니다.   
```
hyeob@hyeob:~/01-start$ export AWS_PROFILE=ap-northeast-1
hyeob@hyeob:~/01-start$ aws configure get region
ap-northeast-1
```

**환경변수**를 제거하기 위해 `unset`을 이용합니다.   
```
unset AWS_PROFILE
```

등록한 환경변수를 제거하면 다시 디폴트값으로 돌아옵니다.   
```
hyeob@hyeob:~/01-start$ aws configure get region
ap-northeast-2
```
