# AWS CloudWatch Slack 알람 설정

## 1. 기존에 생성된 슬랙 앱에서 채널을 생성하고 웹훅 URL 받기

먼저 **기존에 생성한 Slack 앱이 없다면** 아래 링크의 가이드를 따라 진행합니다.   
=> [Slack 앱 생성 후 Webhook URL 받기](https://blog.cowkite.com/blog/2001151846/)

슬랙 앱에서 알람을 받기를 원하는 **채널을 추가**합니다.   
![image](https://user-images.githubusercontent.com/43658658/162347872-91846ec2-09a9-45da-b623-81148b085db7.png)

`워크스페이스 이름 > 관리 > 앱 관리`를 클릭합니다.   
![image](https://user-images.githubusercontent.com/43658658/162348130-4d0249cc-281a-4309-a08c-17401356aa3d.png)

상단의 앱 디렉토리 검색에서 `webhook` 키워드를 작성하면 `수신 웹후크`가 나타납니다.   
![image](https://user-images.githubusercontent.com/43658658/162348651-bef75ee0-f7fa-4e24-8ee4-f318904cda50.png)

`Slack에 추가`버튼을 눌러줍니다.   
![image](https://user-images.githubusercontent.com/43658658/162348701-86f89eec-060b-444a-a75a-1a5852f96bc9.png)

위에서 생성했던 **채널을 선택**하고, `수신 웹후크 통합 앱 추가` 버튼을 누릅니다.   
![image](https://user-images.githubusercontent.com/43658658/162348825-925c0bcb-5662-4cf4-a4d8-769c10904504.png)

자신의 **웹훅 URL**이 나타납니다.   
![image](https://user-images.githubusercontent.com/43658658/162349052-9410000f-f9c3-4f44-8004-29f8de3b03f7.png)

생성한 채널에도 메시지가 와있는 것을 확인할 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/162349280-a872fcc4-cb49-4f22-9802-8803d097fded.png)

`incoming-webhook`을 눌러 `구성`으로 접속하면 `수신 웹후크` 앱이 나타나고, `구성`탭으로 접속하면 자신이 생성한 웹훅 구성이 있음을 확인할 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/162349517-f1ca7aef-3fe8-4e50-99c2-5fc728c47d1d.png)

웹훅이 정확하게 동작하는지 테스트 하기 위해 웹훅 URL로 curl을 날려봅니다.   
```
curl -X POST -H 'Content-type: application/json' --data '{"text":"Hello, World!"}' <자신의 웹훅 URL>
```

채널에 메시지가 와있는 것을 확인할 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/162349826-38178b18-23d6-4aff-a2a7-22c439ce2716.png)

## 2. AWS SNS 주제 생성

AWS 콘솔의 SNS로 접속해 `주제 생성` 버튼을 클릭해 주제를 생성합니다.   
![image](https://user-images.githubusercontent.com/43658658/162350140-96e8526e-5d2a-417a-9920-2aa0215ad416.png)

이후에 `lambda`가 구독하도록 하기 위해 `표준`으로 설정하고, 이름을 명명합니다.   
(다른 아래에 추가적인 설정 사항은 필요 시 진행합니다)   
![image](https://user-images.githubusercontent.com/43658658/162350337-90e4e94d-d437-45d0-9a53-99d3fd1053d9.png)

주제가 생성되었습니다.   
![image](https://user-images.githubusercontent.com/43658658/162350623-3267231e-aaad-49d9-90dd-7c773f77551e.png)

## 3. AWS Lambda 생성

