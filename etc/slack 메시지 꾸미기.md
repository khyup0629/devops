# slack 메시지 꾸미기

(참고!) [Slack Block Kit Builder](https://app.slack.com/block-kit-builder/T025V9S2DGR#%7B%22blocks%22:%5B%7B%22type%22:%22section%22,%22text%22:%7B%22type%22:%22mrkdwn%22,%22text%22:%22Hello,%20Assistant%20to%20the%20Regional%20Manager%20Dwight!%20*Michael%20Scott*%20wants%20to%20know%20where%20you'd%20like%20to%20take%20the%20Paper%20Company%20investors%20to%20dinner%20tonight.%5Cn%5Cn%20*Please%20select%20a%20restaurant:*%22%7D%7D,%7B%22type%22:%22divider%22%7D,%7B%22type%22:%22section%22,%22text%22:%7B%22type%22:%22mrkdwn%22,%22text%22:%22*Farmhouse%20Thai%20Cuisine*%5Cn:star::star::star::star:%201528%20reviews%5Cn%20They%20do%20have%20some%20vegan%20options,%20like%20the%20roti%20and%20curry,%20plus%20they%20have%20a%20ton%20of%20salad%20stuff%20and%20noodles%20can%20be%20ordered%20without%20meat!!%20They%20have%20something%20for%20everyone%20here%22%7D,%22accessory%22:%7B%22type%22:%22image%22,%22image_url%22:%22https://s3-media3.fl.yelpcdn.com/bphoto/c7ed05m9lC2EmA3Aruue7A/o.jpg%22,%22alt_text%22:%22alt%20text%20for%20image%22%7D%7D,%7B%22type%22:%22section%22,%22text%22:%7B%22type%22:%22mrkdwn%22,%22text%22:%22*Kin%20Khao*%5Cn:star::star::star::star:%201638%20reviews%5Cn%20The%20sticky%20rice%20also%20goes%20wonderfully%20with%20the%20caramelized%20pork%20belly,%20which%20is%20absolutely%20melt-in-your-mouth%20and%20so%20soft.%22%7D,%22accessory%22:%7B%22type%22:%22image%22,%22image_url%22:%22https://s3-media2.fl.yelpcdn.com/bphoto/korel-1YjNtFtJlMTaC26A/o.jpg%22,%22alt_text%22:%22alt%20text%20for%20image%22%7D%7D,%7B%22type%22:%22section%22,%22text%22:%7B%22type%22:%22mrkdwn%22,%22text%22:%22*Ler%20Ros*%5Cn:star::star::star::star:%202082%20reviews%5Cn%20I%20would%20really%20recommend%20the%20%20Yum%20Koh%20Moo%20Yang%20-%20Spicy%20lime%20dressing%20and%20roasted%20quick%20marinated%20pork%20shoulder,%20basil%20leaves,%20chili%20&%20rice%20powder.%22%7D,%22accessory%22:%7B%22type%22:%22image%22,%22image_url%22:%22https://s3-media2.fl.yelpcdn.com/bphoto/DawwNigKJ2ckPeDeDM7jAg/o.jpg%22,%22alt_text%22:%22alt%20text%20for%20image%22%7D%7D,%7B%22type%22:%22divider%22%7D,%7B%22type%22:%22actions%22,%22elements%22:%5B%7B%22type%22:%22button%22,%22text%22:%7B%22type%22:%22plain_text%22,%22text%22:%22Farmhouse%22,%22emoji%22:true%7D,%22value%22:%22click_me_123%22%7D,%7B%22type%22:%22button%22,%22text%22:%7B%22type%22:%22plain_text%22,%22text%22:%22Kin%20Khao%22,%22emoji%22:true%7D,%22value%22:%22click_me_123%22,%22url%22:%22https://google.com%22%7D,%7B%22type%22:%22button%22,%22text%22:%7B%22type%22:%22plain_text%22,%22text%22:%22Ler%20Ros%22,%22emoji%22:true%7D,%22value%22:%22click_me_123%22,%22url%22:%22https://google.com%22%7D%5D%7D%5D%7D)에서 템플릿을 구성해 볼 수 있습니다.

**아래 코드**는 `AWS Lambda`를 이용한 방식으로 작성되었습니다.   
(따라서, `slackChannel`과 `hookUrl`에 환경변수가 지정되어 있습니다)

핵심은 `slack_message` 부분입니다.   
**slack_message** 부분에서 메시지의 **UI**를 만들 수 있습니다.

### <코드>

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
    alarm_description = message['AlarmDescription']
    old_state = message['OldStateValue']
    new_state = message['NewStateValue']
    reason = message['NewStateReason']
    change_time = message['StateChangeTime']

    color = "#30db3f" if alarm_name.find("off") >= 0 else "#eb4034"

    slack_message = {
    	"blocks": [
        	{
            "type": "section",
            "text": {
              "type": "mrkdwn",
              "text": ":star:*알림 발생!*\n 아래 내용을 확인해주세요"
            }
          },
          {
            "type": "divider"
          },
          {
            "type": "section",
            "text": {
              "type": "mrkdwn",
              "text": "*경보 내용:*\n" + alarm_description
            }
          },
          {
            "type": "divider"
          }
        ],
		"attachments": [{
            "color": color,
            "blocks": [
	            {
	                "type": "section",
	                "fields": [
	                    {
	                        "type": "mrkdwn",
	                        "text": '*경보 이름:*\n' + alarm_name
	                    },
	                    {
	                        "type": "mrkdwn",
	                        "text": '*경보 시간:*\n' + change_time
	                    }
	                ]
	            },
	            {
	                "type": "section",
	                "fields": [
	                    {
	                        "type": "mrkdwn",
	                        "text": '*상태 변경 전:*\n' + old_state
	                    },
	                    {
	                        "type": "mrkdwn",
	                        "text": '*상태 변경 후:*\n' + new_state
	                    }
	                ]
	            },
	            {
                  "type": "section",
                  "text": {
                    "type": "mrkdwn",
                    "text": "*바로가기 :*\n https://ap-northeast-2.console.aws.amazon.com/cloudwatch/home?region=ap-northeast-2#home:"
                  }
              }
            ]
      }]
	  }


    req = Request(HOOK_URL, json.dumps(slack_message).encode('utf-8'))
    try:
        response = urlopen(req)
        response.read()
    except HTTPError as e:
        logger.error("Request failed: %d %s", e.code, e.reason)
    except URLError as e:
        logger.error("Server connection failed: %s", e.reason)
```

### <코드 세부 설명>

- `attachments` : 결과화면에서 빨간 선 세로 줄로 들여쓰기 된 부분을 나타냅니다.
- 이벤트가 발생하면, message 내용 부분까지 파싱한 후, 아래의 해당 항목들을 변수로 뽑아냅니다.
  - `alarm_name = message['AlarmName']`
  - `alarm_description = message['AlarmDescription']`
  - `old_state = message['OldStateValue']`
  - `new_state = message['NewStateValue']`
  - `reason = message['NewStateReason']`
  - `change_time = message['StateChangeTime']`
- `slack_message`에 JSON 형식으로 내용을 담아 request 합니다.
- `:이모티콘이름:`의 형식으로 문자열 내부에 이모티콘을 쓸 수 있습니다.
 

### <결과 화면>   
![image](https://user-images.githubusercontent.com/43658658/162715681-58a9d0de-1333-4070-a389-e6c8a248ecf1.png)

그냥 무지성으로 `Slack Block Kit Builder`로 만든 템플릿을 쓰면 안돼서 트러블 슈팅 과정이 조금 필요했습니다.   
- 버튼을 만드는 기능이 먹히지 않았습니다.



