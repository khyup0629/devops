# 프로메테우스 Alertmanager

![image](https://user-images.githubusercontent.com/43658658/154841379-7a72f620-f097-46e6-9db2-415362e42b5f.png)   
- **Slack** 뿐만 아니라 **이메일** 등도 가능해요.

## 1. Setup & Configuration

`alertmanager`의 **config 파일**을 만듭니다.
```
cd devops_prometheus/config/alertmanager
vim config.yml
```

#### config.yml

그냥 `Copy & Paste` 하면 안됩니다.   
``` python
global:
  slack_api_url: 'https://hooks.slack.com/services/xxx'
  smtp_smarthost: 'smtp.gmail.com:587'
  smtp_auth_username: 'example@gmail.com' # 자신의 구글 계정을 입력합니다.
  smtp_auth_identity: 'example@gmail.com' # 자신의 구글 계정을 입력합니다.
  smtp_auth_password: 'xxx' # myaccount.google.com > 보안 > 앱 비밀번호

route:
  receiver: 'default-receiver' # 디폴트 receiver
  group_interval: 30s # 동일한 group alarm이 발생 했을 때 노티 재발생 주기
  group_wait: 5s # 해당 group 알람이 왔을 때 대기 시간
  group_by: [ alertname ] # 특정 label을 적어서 같은 label끼리 그룹화
  routes: # 알람이 오면 route에 정의된 receiver들을 돕니다.
    - receiver: 'slack-notifications' # 슬랙에 보냅니다.
      continue: true # default false # true면 아래로 진행하고, false면 이메일 알람을 보내지 않고 멈춥니다.
    - receiver: 'email-notifications'
      continue: false

receivers: # receiver에 대한 개별 설정
  - name: 'default-receiver'
  - name: 'email-notifications' # 이메일 노티
    email_configs:
      - to: 'example@gmail.com' # 이메일 발신자
        from: 'example@gmail.com' # 이메일 
  - name: 'slack-notifications' # 슬랙 노티
    slack_configs:
    - channel: '#alert' # 알람을 보낼 채널
#      title: "{{ range .Alerts }}{{ .Annotations.summary }}\n{{ end }}"
#      text: "{{ range .Alerts }}{{ .Annotations.description }}\n{{ end }}"
      username: 'prometheus' # 메시지를 보내는 유저이름
      send_resolved: false
      title: |- # 메시지 제목
        [{{ .Status | toUpper }}{{ if eq .Status "firing" }}:{{ .Alerts.Firing | len }}{{ end }}] {{ .CommonLabels.alertname }} for {{ .CommonLabels.job }}
      text: >- # 메시지 내용
        {{ range .Alerts -}}
        *Alert:* {{ .Annotations.title }}{{ if .Labels.serverity }} - `{{ .Labels.serverity }}`{{ end }}

        *Description:* {{ .Annotations.description }}

        *Details:*
          {{ range .Labels.SortedPairs }} • *{{ .Name }}:* `{{ .Value }}`
          {{ end }}
        {{ end }}

inhibit_rules:
  - source_match: # 소스가 감지되면 타겟을 노출 시킵니다.
      severity: 'critical' # 'critical'이 감지되면,
    target_match:
      severity: 'warning' # 'warning'을 노출시키겠다.
    equal: [alertname]

templates: [] # 메시지를 템플릿으로 만들어 재사용할 수 있도록 해주는 기능.
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

## 2. 프로메테우스와 alertmanager 연동

```
cd devops_prometheus/config/prometheus/prometheus.yml
vim dj.alerts.yaml
```

#### prometheus.yml

alert와 관련한 `.yaml` 파일 부분입니다.   
``` python
rule_files:
  - /etc/prometheus/rules/*.yaml

alerting:
  alertmanagers:
  - scheme: http
    api_version: v2
    path_prefix: /
    static_configs: # 동적(ec2, sd) 타겟 설정도 가능
    - targets: # alertmanager의 고가용성(HA)를 위해 2개를 두고 클러스터링을 진행합니다.
      - "alertmanager_1:9082"
      - "alertmanager_2:9084"
```

## 3. alerting rule 설정

```
cd devops_prometheus/compose-files/prometheus/rules/
vim dj.alerts.yaml
```

#### dj.alerts.yaml

이곳에 알람과 관련된 rules가 설정됩니다.   
``` python
groups:
  - name: prometheus-cpu
    interval: 10s
    rules:
      - alert: alerts:cpu_usage:prometheus:80
        expr: rate(process_cpu_seconds_total{job=~"prometheus"}[1m]) * 100 > 80 # alert 조건이 들어가는 부분
        for: 5s
        labels:
          service: prometheus
          serverity: critical
        annotations:
          title: "Prometheus CPU alert 80%"
          summary: "{{ $labels.instance }}: {{ $value }} ( {{ $labels.job }} )"
          description: "{{ $labels.instance }}: {{ $value }} ( {{ $labels.job }} )"

  - name: blackbox-monitor
    interval: 10s
    limit: 0
    rules:
      - alert: alerts:probe_success
        expr: probe_success == 0
        for: 5s
        labels:
          serverity: critical
        annotations:
          title: "black-box monitoring alert"
          summary: "black-box monitoring alert ( {{ $labels.job }} )"
          description: "{{ $labels.instance }} is down"
```   
- `process_cpu_seconds_total` : CPU 사용률
- `probe_success` : 0이면 서버가 다운된 상태입니다.

설정한 rules에 관련된 내용은 프로메테우스 브라우저에서 `Status > Rules`에 들어가면 확인 가능해요.   
![image](https://user-images.githubusercontent.com/43658658/154844501-f30f65fe-7f1d-4796-83de-50c58b261151.png)

## 알림 테스트

먼저 blackbox-monitor와 관련된 3개의 서버에 대한 알림을 테스트 해보겠습니다.   
![image](https://user-images.githubusercontent.com/43658658/154845896-23245c78-3d19-45c0-b17a-ddf58aeb8629.png)

nginx 컨테이너를 다운시킵니다.   
```
cd /devops_prometheus/compose-files/nginx
docker-compose down
```

`probe_success` 지표는 서버가 다운되면 0이 됩니다. 서버가 업되면 1입니다.   
![image](https://user-images.githubusercontent.com/43658658/154845981-e86ed5b9-50b6-4894-aec4-13b6055b114a.png)

`ALERTS`를 통해 쿼리해보면 `80`번 포트에 대해 알람이 발생(`1`)한 것을 볼 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/154846035-16167a7b-f035-4506-b442-521ad2ff5c87.png)

## alertmanager 컨테이너 올리기

`alertmanager`를 위한 `docker-compose`파일을 살펴봅시다.   
```
cd /devops_prometheus/compose-files/alertmanager
vim docker-compose.yml
```

#### docker-compose.yml

``` python
version: '3.8'
services:
  alertmanager_1:
    image: prom/alertmanager:latest
    container_name: alertmanager_1
    ports:
      - "9082:9082"
    volumes:
      - ../../config/alertmanager/config.yml:/etc/alertmanager/config.yml
    command:
      - '--config.file=/etc/alertmanager/config.yml' # config 파일 경로 설정
      - '--data.retention=48h'
      - '--log.level=debug'
      - '--cluster.listen-address=0.0.0.0:9083' # 클러스터링 포트 설정
      - '--web.listen-address=0.0.0.0:9082' # 웹에서는 9082번 포트로 접근
  alertmanager_2:
    image: prom/alertmanager:latest
    container_name: alertmanager_2
    ports:
      - "9084:9084"
    volumes:
      - ../../config/alertmanager/config.yml:/etc/alertmanager/config.yml
    command:
      - '--config.file=/etc/alertmanager/config.yml'
      - '--data.retention=48h'
      - '--log.level=debug'
      - '--cluster.listen-address=0.0.0.0:9085'
      - '--cluster.peer=alertmanager_1:9083' # alertmanager_1과 9083번 포트로 클러스터 피어 설정
      - '--web.listen-address=0.0.0.0:9084' # 웹에서는 9084번 포트로 접근

networks:
  default:
    external:
      name: monitoring
```

`alertmanager` 2개의 컨테이너를 올립니다.   
```
docker-compose up -d
docker-compose ps
```

`9082`번 포트와 `9084`번 포트로 접근하면 아래와 같이 `alertmanager` 웹 브라우저가 나타납니다.   
![image](https://user-images.githubusercontent.com/43658658/154846466-f09e80d2-7931-45dc-b484-c0df8bbb47da.png)

`Status` 탭으로 접근해보면 클러스터 리스너가 설정대로 지정되어 있고, 피어 역시 지정되어 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/154846637-3090178b-e680-449f-b752-426efd2a0803.png)

`Slack`의 `#alert` 채널로 가보면 알림이 오는 것을 확인할 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/154846666-22d1cdbd-9e10-45e7-848d-e47215d35c4b.png)   
- config에서 설정한대로 `1분` 주기로 알림이 옵니다.

`config.yml`에서 지정한 **이메일**로도 알림이 오는 것을 확인할 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/154846856-0a73a414-80a5-4213-ada3-f77c26a3572b.png)

`alertmanager`에서도 현재 발생되고 있는 alert에 대해 확인할 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/154846831-d83f3068-8cc3-4547-9d93-f33aded9d6d0.png)

이번엔 **프로메테우스**의 **CPU** 조건을 80이 아닌 `0`으로 변경해서 알림을 발생시켜 보겠습니다.   
```
cd /devops_prometheus/compose-files/prometheus/rules
vim dj.alerts.yaml
```   
![image](https://user-images.githubusercontent.com/43658658/154846997-7dc2a0c3-739f-459a-ac33-d4c0a9bf9b20.png)

프로메테우스 컨테이너를 재시작합니다.   
```
cd ..
docker-compose down; docker-compose up -d
```

알림이 발생하기 시작합니다.   
![image](https://user-images.githubusercontent.com/43658658/154847118-8b59d6b9-092a-484b-8bfe-0e5f742aad53.png)

지속적인 알림 발생을 멈추기 위해서는 `alertmanager`에서 `Slience` 기능을 이용합니다.   
![image](https://user-images.githubusercontent.com/43658658/154847225-d6aca701-310d-4555-9d76-b896a60844b8.png)   
![image](https://user-images.githubusercontent.com/43658658/154847329-a52eaf69-1f8e-491a-ae0d-541948c781b2.png)

