# Grafana Alert 설정

## CPU 사용량 80% 이상 Alert

먼저 그라파나 페이지에서 `Alerting > Alert rules`로 접근해 [New alert rule] 버튼을 누릅니다.   
![image](https://user-images.githubusercontent.com/43658658/155485225-bd285798-a3b2-4269-86a9-df711354aa7c.png)

아래와 같이 `Grafana managed alert`를 선택합니다.   
![image](https://user-images.githubusercontent.com/43658658/155485316-042e4f4e-2121-43c1-9478-5b7f259ce424.png)

기존 CPU 사용량 패널의 쿼리를 불러오고, 그 밑에 쿼리를 하나 새로 생성합니다.   
![image](https://user-images.githubusercontent.com/43658658/155485558-4c31ec1e-14fd-46b4-a5f1-e3180a03c7eb.png)   
- A 쿼리의 의미는 B 쿼리의 결과값에서 80 이상인 값들을 쿼리한다는 뜻입니다.

알림을 발생시킬 조건 쿼리문을 선택합니다.   
![image](https://user-images.githubusercontent.com/43658658/155485760-2d390217-76de-4921-9c06-7e550651aacf.png)   
- 쿼리를 평가하는 주기 : 10초
- 쿼리의 조건이 위반되면 pending 상태가 되는데 pending 상태가 30초 이상이면 알람 발생.

`annotations`를 작성합니다(이후에 template에서 annotation으로 조회 가능)   
![image](https://user-images.githubusercontent.com/43658658/155495697-1871f110-4743-48f8-a23a-2c4e97fcca21.png)

> <h3>Slack 알림 설정</h3>

이제 `contact points` 탭으로 접근합니다.   
![image](https://user-images.githubusercontent.com/43658658/155491459-d8081531-351a-4e1b-a989-ad3ba09935e5.png)

[New contact point] 버튼을 누릅니다.   
![image](https://user-images.githubusercontent.com/43658658/155491571-c008b262-8a5f-4923-acd6-9c96460df974.png)

이름을 작성하고 `Slack`을 선택합니다.   
![image](https://user-images.githubusercontent.com/43658658/155491743-b5be5318-7764-4cef-8cec-750c82a13b0d.png)

Slack Webhook URL을 입력하고, `template`의 이름을 작성합니다.   
![image](https://user-images.githubusercontent.com/43658658/155492083-e8cd77ee-0394-4423-88fa-78a8d6b3527d.png)   
- `{{ template "<템플릿 이름>" . }}` :  나중에 `message template`을 추가할 때 `{{ define '<템플릿 이름>' }}` 구문을 작성해 템플릿 파일을 만들고, 이 파일과 연결됩니다.

다음으로 `Message template`을 만듭니다.   
![image](https://user-images.githubusercontent.com/43658658/155492317-33a16ef4-cec3-45ab-b08d-3a915794810d.png)

아래와 같이 템플릿 이름과 내용을 작성합니다.   
![image](https://user-images.githubusercontent.com/43658658/155492612-a36d957b-6ad9-4a2c-a494-b1177f15d675.png)   
```
*Alert details*: 
   {{ range .Alerts }}
*Value:* 
{{ or .ValueString "[no value]" }}
*Description:* {{ .Annotations.description }}
*Detail:* 
{{ range .Labels.SortedPairs }} ♪ {{ .Name }}: `{{ .Value }}`
{{ end }}

   {{ end }}
{{ end }}
```   
- `*<문자열>*` : 굵은 글씨 출력.
- `{{ range .Alerts }}` : alert이 발생한 만큼 loop를 돕니다.
- `{{ or .ValueString "[no value]" }}` : alert이 발생했을 때 value값을 나타냅니다.
- `{{ .Annotations.<항목> }}` : `alert rules`를 생성할 때 4번 항목에서 작성한 `URL, Description` 등을 조회합니다.
- `{{ range .Labels.SortedPairs }}` : 발생한 alert의 label의 key-`{{ .Name }}`, value-`{{ .Value }}`들을 모두 출력.

`Notification policies`에 접근해 [Edit] 버튼을 누릅니다.   
![image](https://user-images.githubusercontent.com/43658658/155505421-69b0d069-8c9b-4655-b8fd-91c1a07476df.png)

앞서 생성한 **Slack 타입 Contact point**를 선택합니다.   
![image](https://user-images.githubusercontent.com/43658658/155505559-6126de8f-7e56-4813-876f-9829698297c8.png)

### 테스트

`alert rules`에서 **CPU 사용량**의 임계치를 `1`로 낮춰봅니다.   
![image](https://user-images.githubusercontent.com/43658658/155492796-c66b084b-0ec0-45b2-8df5-c51a6de4b89d.png)

일정 시간 후에 `Slack`에 알림이 오는 것을 확인할 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/155492964-5a9d1b88-40aa-4bc8-8bd1-9dc7be7e620d.png)

> <h3>이메일 알림 설정</h3>

**이메일 알림 설정**을 위해선 먼저 그라파나에서 `SMTP` 설정을 진행해야 합니다.   
```
docker ps  // 그라파나의 컨테이너 ID를 확인합니다.
docker exec -it --user root <그라파나 컨테이너 ID> /bin/bash
cd conf
vi defaults.ini
```

#### defaults.ini

`SMTP` 설정을 아래와 같이 진행합니다.   
![image](https://user-images.githubusercontent.com/43658658/155493576-1837cea0-f767-40cf-9782-991b7ed84c57.png)   
- SMTP 호스트 이름, 포트 번호의 경우 이메일을 받고 싶은 `계정의 앱`으로 접속해서 설정 중 `SMTP 관련된 설정`을 찾아보시면 됩니다.

설정 적용을 위해 컨테이너를 **재시작**합니다.   
```
exit
docker restart <그라파나 컨테이너 ID>
```

다시 [New contact point] 버튼을 누릅니다.   
![image](https://user-images.githubusercontent.com/43658658/155493917-4c29379f-2ee9-4632-b48a-c24338b4aa00.png)

이름을 작성하고, 타입은 `Email`로 합니다.   
![image](https://user-images.githubusercontent.com/43658658/155494108-ab6b0501-3070-4876-bee5-1dfaa5aa6ceb.png)

`Notification Policies`로 들어가서 [New policy] 버튼을 누릅니다.   
![image](https://user-images.githubusercontent.com/43658658/155504986-67dc55f7-667a-49fe-8771-80c9e4089181.png)

[Add matcher] 버튼을 눌러서 Label 조건을 적어주고, `Contact point`는 앞서 생성한 **Email 타입 Contact point**로 선택합니다.   
![image](https://user-images.githubusercontent.com/43658658/155505239-5c37382c-062b-4df7-94ed-a2324f31c7ce.png)

### 테스트

마찬가지로 CPU 사용량의 기준을 `1`로 설정해서 테스트를 진행해봅니다.

이메일을 통해 정상적으로 알림이 오는 것을 확인할 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/155494311-690148ed-2101-4b90-afb8-38e93ed3fc92.png)

