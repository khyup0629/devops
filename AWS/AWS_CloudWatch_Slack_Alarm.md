# AWS CloudWatch Slack 알람 설정

## 1. 기존에 생성된 슬랙 앱에서 채널을 생성하고 웹훅 URL 받기

먼저 **기존에 생성한 Slack 앱이 없다면** 아래 링크의 가이드를 따라 진행합니다.   
=> [Slack 앱 생성 후 Webhook URL 받기](https://blog.cowkite.com/blog/2001151846/)

1. 슬랙 앱에서 알람을 받기를 원하는 **채널을 추가**합니다.   
채널을 추가할 땐 반드시 **공개 방식으로 추가**해야합니다.   
(비공개 방식으로 추가하면 알림이 오지 않습니다)   
![image](https://user-images.githubusercontent.com/43658658/162377315-c55a3ed7-ff8c-490a-bb26-7bbc74cbb379.png)

2. `워크스페이스 이름 > 관리 > 앱 관리`를 클릭합니다.   
![image](https://user-images.githubusercontent.com/43658658/162351462-c9fd3a2c-8a61-4635-9a75-9b00052dd9b2.png)

3. 상단의 앱 디렉토리 검색에서 `webhook` 키워드를 작성하면 `수신 웹후크`가 나타납니다.   
![image](https://user-images.githubusercontent.com/43658658/162348651-bef75ee0-f7fa-4e24-8ee4-f318904cda50.png)

4. `Slack에 추가`버튼을 눌러줍니다.   
![image](https://user-images.githubusercontent.com/43658658/162348701-86f89eec-060b-444a-a75a-1a5852f96bc9.png)

5. 위에서 생성했던 **채널을 선택**하고, `수신 웹후크 통합 앱 추가` 버튼을 누릅니다.   
![image](https://user-images.githubusercontent.com/43658658/162348825-925c0bcb-5662-4cf4-a4d8-769c10904504.png)

6. 자신의 **웹훅 URL**이 나타납니다.   
![image](https://user-images.githubusercontent.com/43658658/162349052-9410000f-f9c3-4f44-8004-29f8de3b03f7.png)

7. 생성한 채널에도 메시지가 와있는 것을 확인할 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/162349280-a872fcc4-cb49-4f22-9802-8803d097fded.png)   
`incoming-webhook`을 눌러 `구성`으로 접속하면 `수신 웹후크` 앱이 나타납니다.   
![image](https://user-images.githubusercontent.com/43658658/162351512-ded84c24-b22f-459f-abce-a1f4e6ad75b5.png)   
`구성`탭으로 접속하면 자신이 생성한 웹훅 구성이 있음을 확인할 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/162349517-f1ca7aef-3fe8-4e50-99c2-5fc728c47d1d.png)

8. 웹훅이 정확하게 동작하는지 **테스트** 하기 위해 웹훅 URL로 curl을 날려봅니다.   
```
curl -X POST -H 'Content-type: application/json' --data '{"text":"Hello, World!"}' <자신의 웹훅 URL>
```

9. **채널에 메시지**가 와있는 것을 확인할 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/162349826-38178b18-23d6-4aff-a2a7-22c439ce2716.png)

## 2. AWS SNS 주제 생성

1. AWS 콘솔의 SNS로 접속해 `주제 생성` 버튼을 클릭해 **주제를 생성**합니다.   
![image](https://user-images.githubusercontent.com/43658658/162350140-96e8526e-5d2a-417a-9920-2aa0215ad416.png)

2. 이후에 `lambda`가 구독하도록 하기 위해 `표준`으로 설정하고, 이름을 명명합니다.   
(다른 아래에 추가적인 설정 사항은 필요 시 진행합니다)   
![image](https://user-images.githubusercontent.com/43658658/162350337-90e4e94d-d437-45d0-9a53-99d3fd1053d9.png)

3. **주제가 생성**되었습니다.   
![image](https://user-images.githubusercontent.com/43658658/162350623-3267231e-aaad-49d9-90dd-7c773f77551e.png)

## 3. AWS Lambda 생성

1. AWS 콘솔에서 `lambda`에 접근합니다.   
![image](https://user-images.githubusercontent.com/43658658/162351617-ac799688-32aa-4cda-affd-969f6cd34993.png)

2. `블루프린트 사용`을 클릭, 필터에 `cloudwatch-alarm-to-slack-python`을 입력하면 해당 항목이 나타납니다. 선택하고 `구성`을 클릭합니다.   
![image](https://user-images.githubusercontent.com/43658658/162351942-13bc04af-69cc-402c-9c0d-a58896cdac02.png)

3. **함수 이름**을 작성하고, **실행 역할**을 선택합니다. 위에서 생성한 **SNS 주제**를 선택합니다.   
![image](https://user-images.githubusercontent.com/43658658/162352313-6c1460cf-199d-4e83-92b8-9d5a8cc3b57c.png)

4. 함수 내용과 환경 변수는 나중에 수정이 가능하니 환경 변수에 임의의 값을 작성하고 넘어갑니다.   
![image](https://user-images.githubusercontent.com/43658658/162356204-bd4ae167-56c9-44b3-91c3-5a02ca8ee048.png)

5. 함수 생성이 완료되었습니다.   
![image](https://user-images.githubusercontent.com/43658658/162352609-d3b290a5-e507-4843-bf05-725ef7166060.png)

6. 생성된 함수의 상제 정보에서 `구성 > 환경 변수`로 접근해 환경 변수를 아래와 같이 수정합니다.   
![image](https://user-images.githubusercontent.com/43658658/162367058-c395c800-435b-422d-a290-60299977a265.png)

7. **코드를 수정**합니다.   
**암호화를 사용하지 않을 것이기 때문에** 암호화와 관련된 변수들(`ENCRYPTED_HOOK_URL`, `HOOK_URL`)을 수정합니다.   
``` python
import boto3
import json
import logging
import os

from base64 import b64decode
from urllib.request import Request, urlopen
from urllib.error import URLError, HTTPError


# The base-64 encoded, encrypted key (CiphertextBlob) stored in the kmsEncryptedHookUrl environment variable
# ENCRYPTED_HOOK_URL = os.environ['kmsEncryptedHookUrl']
# The Slack channel to send a message to stored in the slackChannel environment variable
SLACK_CHANNEL = os.environ['slackChannel']

# HOOK_URL = "https://" + boto3.client('kms').decrypt(
#     CiphertextBlob=b64decode(ENCRYPTED_HOOK_URL),
#     EncryptionContext={'LambdaFunctionName': os.environ['AWS_LAMBDA_FUNCTION_NAME']}
# )['Plaintext'].decode('utf-8')

HOOK_URL = os.environ['hookUrl']

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def lambda_handler(event, context):
    logger.info("Event: " + str(event))
    message = json.loads(event['Records'][0]['Sns']['Message'])
    logger.info("Message: " + str(message))

    alarm_name = message['AlarmName']
    #old_state = message['OldStateValue']
    new_state = message['NewStateValue']
    reason = message['NewStateReason']

    slack_message = {
        'channel': SLACK_CHANNEL,
        'text': "%s state is now %s: %s" % (alarm_name, new_state, reason)
    }

    req = Request(HOOK_URL, json.dumps(slack_message).encode('utf-8'))
    try:
        response = urlopen(req)
        response.read()
        logger.info("Message posted to %s", slack_message['channel'])
    except HTTPError as e:
        logger.error("Request failed: %d %s", e.code, e.reason)
    except URLError as e:
        logger.error("Server connection failed: %s", e.reason)
```

## 4. CloudWatch 경보 설정

1. 원하는 지표로 CloudWatch의 경보를 생성합니다.   
![image](https://user-images.githubusercontent.com/43658658/162355427-e88cd1bb-2676-4486-a4fc-a51dbf006464.png)

**CPU 지표**를 생성합니다.   
![image](https://user-images.githubusercontent.com/43658658/162375561-74d3e992-f169-4e0c-83eb-56215d7d68c8.png)

생성 과정에서 **SNS 주제를 선택**합니다.      
![image](https://user-images.githubusercontent.com/43658658/162355764-a475d662-c03e-41ec-8e49-19ef9017af91.png)

2. 경보가 생성되었습니다.   
![image](https://user-images.githubusercontent.com/43658658/162375676-99902be7-173e-41d8-8f7b-2854d743535c.png)

## 5. 알람 테스트

1. AWS Lambda에서 생성한 함수의 세부 정보로 접근해 `테스트` 탭으로 접근합니다.   
![image](https://user-images.githubusercontent.com/43658658/162367555-dcb5b787-15c2-43e4-98e9-dff941451843.png)

2. 새 이벤트를 생성합니다. 
![image](https://user-images.githubusercontent.com/43658658/162372445-8d7a9c07-5fb5-42eb-857a-2ce8b9476393.png)   
이벤트 JSON은 아래와 같이 작성합니다.   
``` json
{
  "Records": [
    {
      "EventSource": "aws:sns",
      "EventVersion": "1.0",
      "EventSubscriptionArn": "arn:aws:sns:eu-west-1:000000000000:cloudwatch-alarms:xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
      "Sns": {
        "Type": "Notification",
        "MessageId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
        "TopicArn": "arn:aws:sns:eu-west-1:000000000000:cloudwatch-alarms",
        "Subject": "ALARM: \"Example alarm name\" in EU - Ireland",
        "Message": "{\"AlarmName\":\"Example alarm name\",\"AlarmDescription\":\"Example alarm description.\",\"AWSAccountId\":\"000000000000\",\"NewStateValue\":\"ALARM\",\"NewStateReason\":\"Threshold Crossed: 1 datapoint (10.0) was greater than or equal to the threshold (1.0).\",\"StateChangeTime\":\"2017-01-12T16:30:42.236+0000\",\"Region\":\"EU - Ireland\",\"OldStateValue\":\"OK\",\"Trigger\":{\"MetricName\":\"DeliveryErrors\",\"Namespace\":\"ExampleNamespace\",\"Statistic\":\"SUM\",\"Unit\":null,\"Dimensions\":[],\"Period\":300,\"EvaluationPeriods\":1,\"ComparisonOperator\":\"GreaterThanOrEqualToThreshold\",\"Threshold\":1.0}}",
        "Timestamp": "2017-01-12T16:30:42.318Z",
        "SignatureVersion": "1",
        "Signature": "Cg==",
        "SigningCertUrl": "https://sns.eu-west-1.amazonaws.com/SimpleNotificationService-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.pem",
        "UnsubscribeUrl": "https://sns.eu-west-1.amazonaws.com/?Action=Unsubscribe&SubscriptionArn=arn:aws:sns:eu-west-1:000000000000:cloudwatch-alarms:xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
        "MessageAttributes": {}
      }
    }
  ]
}
```   
+) 람다의 파이썬 코드는 위 JSON 형식에 맞춰서 작성되어 있기 때문에, 위의 JSON 형식을 벗어나면 `JSONDecodeError` 에러가 발생합니다.

3. 저장 버튼을 누르고, 테스트 버튼을 눌러 이벤트를 수행해볼 수 있습니다.   
슬랙에 정상적으로 알림이 오는 것을 확인할 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/162377605-0efcdede-7a34-4d99-97a0-7383010eddcc.png)

(참고)간혹 아래와 같이 `Timeout` 에러가 뜰 수 있습니다.   
```
Test Event Name
test

Response
{
  "errorMessage": "2022-04-08T05:20:27.294Z 99a755e7-91a5-4e20-a512-85c0eee91187 Task timed out after 3.04 seconds"
}

Function Logs
START RequestId: 99a755e7-91a5-4e20-a512-85c0eee91187 Version: $LATEST
END RequestId: 99a755e7-91a5-4e20-a512-85c0eee91187
REPORT RequestId: 99a755e7-91a5-4e20-a512-85c0eee91187	Duration: 3040.69 ms	Billed Duration: 3000 ms	Memory Size: 128 MB	Max Memory Used: 21 MB	
2022-04-08T05:20:27.294Z 99a755e7-91a5-4e20-a512-85c0eee91187 Task timed out after 3.04 seconds

Request ID
99a755e7-91a5-4e20-a512-85c0eee91187
```

이럴 땐 해당 함수의 세부 정보에서 `구성 > 일반 구성`으로 접근해 `편집` 버튼을 눌러 **제한 시간**을 늘려주면 됩니다.   
![image](https://user-images.githubusercontent.com/43658658/162370302-3fc2020e-0d2f-48c8-b771-c56e5d62c1bc.png)
