# 프로메테우스 Alertmanager

![image](https://user-images.githubusercontent.com/43658658/154841379-7a72f620-f097-46e6-9db2-415362e42b5f.png)   
- 슬랙 뿐만 아니라 이메일 등도 가능해요.

## 1. Setup & Configuration

그냥 Copy & Paste 하면 안됩니다.   
``` python
global:
  slack_api_url: 'https://hooks.slack.com/services/xxx'
  smtp_smarthost: 'smtp.gmail.com:587'
  smtp_auth_username: 'example@gmail.com' # 자신의 구글 계정을 입력합니다.
  smtp_auth_identity: 'example@gmail.com' # 자신의 구글 계정을 입력합니다.
  smtp_auth_password: 'xxx' # myaccount.google.com > 보안 > 앱 비밀번호

route:
  receiver: 'default-receiver'
  group_interval: 30s # 동일한 group alarm이 발생 했을 때 노티 재발생 주기
  group_wait: 5s # 해당 group 알람이 왔을 때 대기 시간
  group_by: [ alertname ]
  routes:
    - receiver: 'slack-notifications'
      continue: true # default false
    - receiver: 'email-notifications'
      continue: false

receivers:
  - name: 'default-receiver'
  - name: 'email-notifications'
    email_configs:
      - to: 'example@gmail.com' # 이메일 발신자
        from: 'example@gmail.com' # 이메일 
  - name: 'slack-notifications'
    slack_configs:
    - channel: '#alert'
#      title: "{{ range .Alerts }}{{ .Annotations.summary }}\n{{ end }}"
#      text: "{{ range .Alerts }}{{ .Annotations.description }}\n{{ end }}"
      username: 'prometheus'
      send_resolved: false
      title: |-
        [{{ .Status | toUpper }}{{ if eq .Status "firing" }}:{{ .Alerts.Firing | len }}{{ end }}] {{ .CommonLabels.alertname }} for {{ .CommonLabels.job }}
      text: >-
        {{ range .Alerts -}}
        *Alert:* {{ .Annotations.title }}{{ if .Labels.serverity }} - `{{ .Labels.serverity }}`{{ end }}

        *Description:* {{ .Annotations.description }}

        *Details:*
          {{ range .Labels.SortedPairs }} • *{{ .Name }}:* `{{ .Value }}`
          {{ end }}
        {{ end }}

inhibit_rules:
  - source_match:
      severity: 'critical'
    target_match:
      severity: 'warning'
    equal: [alertname]

templates: []
```   

> <h3>Slack API URL 설정하기</h3>

슬랙에서 채널을 하나 생성합니다.   
![image](https://user-images.githubusercontent.com/43658658/154842465-09101d00-0393-46b0-b9c2-41f96fdb44f8.png)   
![image](https://user-images.githubusercontent.com/43658658/154842494-7a932605-933f-4f68-acb4-56c669a5358d.png)

=> https://api.slack.com 으로 접속합니다.

`Create an app` 버튼을 누릅니다.   
![image](https://user-images.githubusercontent.com/43658658/154842315-d857c46d-000f-4f52-99da-ec51d3fdb520.png)

`From Scratch`를 누릅니다.   
![image](https://user-images.githubusercontent.com/43658658/154842369-a6b5c5bf-8f7f-4be7-a6d2-1622e3915c5e.png)

`App Name`을 작성하고, `alert` 채널을 생성한 워크스페이스를 고릅니다.   
![image](https://user-images.githubusercontent.com/43658658/154842657-91669736-ced6-49b1-a2c8-6c5bc3f052c5.png)

`Incoming Webhooks`로 접속합니다.   
![image](https://user-images.githubusercontent.com/43658658/154842684-ec314715-7ea9-44dc-b335-623af27e197e.png)

`Incoming Webhooks`를 활성화해주고, `Add New Webhook to Workspace`를 누릅니다.   
![image](https://user-images.githubusercontent.com/43658658/154842714-f1af8a47-fc40-4e4b-b763-c57db0077ba3.png)

`alert` 채널을 선택합니다.   
![image](https://user-images.githubusercontent.com/43658658/154842734-62e21df7-d274-4429-a85f-1655a7949fa9.png)

`Webhook URL`을 `Copy`합니다.   
![image](https://user-images.githubusercontent.com/43658658/154842754-a26379c6-b968-462c-ba83-beb872f52826.png)

`config.yml` 파일의 `slack_api_url`에 붙여넣습니다.
![image](https://user-images.githubusercontent.com/43658658/154842800-ceb73afc-1fd8-4c7e-8534-7c570076daf5.png)

> <h3>smtp_auth_password 설정 방법</h3>

=> https://myaccount.google.com 으로 접속합니다.

`보안 > 앱 비밀번호`로 접근합니다.   
![image](https://user-images.githubusercontent.com/43658658/154842059-0c2384f0-0d6c-455a-ae31-25668fa3e959.png)

**앱 비밀번호**를 생성할 `앱`과 `기기`를 다음과 같이 선택합니다.   
![image](https://user-images.githubusercontent.com/43658658/154842082-f16f1c75-3ac1-4aa7-b37f-e6ad36704144.png)   
![image](https://user-images.githubusercontent.com/43658658/154842104-c4687bbb-b6bb-4fd3-bdf1-903c9603915c.png)

**비밀번호를 복사**해서 `config.yml` 파일의 `smtp_auth_password`에 적어넣습니다.   
![image](https://user-images.githubusercontent.com/43658658/154842132-38d4742c-1fc4-4ec8-9f58-0098085288b8.png)


