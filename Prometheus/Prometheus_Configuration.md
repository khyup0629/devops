## 프로메테우스 Configuration

> <h3>command-line flags</h3>

- `Docker-compose.yml` 파일의 `command:`에 들어가는 요소
- ex) 평소 얼마만큼의 데이터를 유지할지, 스토리지의 위치 등

> <h3>configuration file</h3>

- `prometheus.yml`
- 프로메테우스 설정 파일에 항목들이 있습니다.
- ex) 프로메테우스 수집과 관련된 항목, alerting 등

``` python
global:
  scrape_interval: 15s   # 스크랩 주기
  scrape_timeout: 10s   # 스크랩 타임아웃
  evaluation_interval: 1m   # rule대로 평가하는 주기
  external_labels: # 시스템의 label
  query_log_file: /etc/prometheus/query.log   # 프로메테우스에 쿼리를 날렸을 때 로그를 남길 경로
```   
``` python
rule_files:
  /etc/prometheus/rules/*.yaml   # rule, alert에 대한 파일
  # rules.yaml: 사전에 PromQL을 캐싱해서 프로메테우스의 부하를 줄이는 역할
  # alerts.yaml: # metric이 설정한 조건을 만족하면 alert
```   
``` python
/etc/prometheus/rules/rules.yaml   
groups:
  name: bllu
  interval: 10s
  limit: 0   # 0: unlimited
  rules:
    record: slice:prometheus_engine_query:speed
    expr: prometheus_engine_query_duration_seconds_sum / on (slice) group_left prometheus_engine_query_duration_seconds_count
    labels:
      bllu: test   # rule로 미리 쿼리한 샘플에 `bllu="test"`로 labeling을 해서 캐시된 샘플임을 알려줄 수 있습니다.
```   
``` python
/etc/prometheus/rules/alerts.yaml
groups:
  name: bllu-alert
  interval: 10s
  limit: 0
  rules:
    alert: alerts:process_cpu_seconds_total:10   # alertname을 레이블링
    expr: process_cpu_seconds_total > 10
    for: 5s   # expr의 조건이 5초 지속되면 alert
    labels:
      bllu: test
      serverity: critical
    annotations:
      summary: "process_cpu_seconds_total: {{ $value }}"
      description: "process_cpu_seconds_total: {{ $value }}"
```   
rules와 alerts은 프로메테우스 페이지의 해당 위치에 명시되어 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/153884970-3977e8c6-0941-4fdb-af1c-d8277fab966d.png)

``` python
scrape_configs:
- job_name: prometheus
  scrape_interval: 10s
  metrics_path: /metrics   # 타겟의 매트릭 경로
  static_configs:  # 정적 타겟을 찾습니다.
  - targets: [ '<IP주소:포트번호>' ]
- job_name: 'bllu-custom-file-sd'
  file_sd_configs:   # file_sd를 읽어서 동적 타겟을 찾습니다(스케일링이 있을 때 동적으로 찾아줍니다).
  - file:
    - /etc/prometheus/sd/bllu_custom.json
    refresh_interval: 10s   # 갱신 주기
ec2_sd_configs:   # ec2 API를 이용해 ec2 인스턴스를 가져옵니다.
- endpoint: ""
  region: ap-northeast-2
  refresh_interval: 10s
  port: 9100
  filters:
  - name: tag:monitoring   # 태그에 monitoring이 true인 ec2를 가져옵니다.
    values:
    - "ture"
```   

``` python
# bllu_custom.json
[
  {
    "targets": [
      "10.0.101.27:9100",
      "10.0.101.82:9100"
    ],
    "labels": {
      "service": "web",
      "role": "role-1"
    }
  }
]
```

- relabeling : label의 meta label 중 하나로 relabeling.   
애초에 label에 나타내는 항목이 아니라면 relabeling 해도 label에 나타나지 않습니다.

``` python
- source_labels: [__meta_ec2_tag_Name]   # Before labeling에서 __meta_ec2_tag_Name 을 instance 로 relabeling 합니다.
  separator: ;
  regex: (.*)   # 정규표현식: (.*)는 전체 문자열을 의미합니다. () : 그룹 지정, . : any character, * : 0 or more
  target_label: instance
  replacement: $1   # source_labels의 value가 바뀌는 형식
  action: replace
```   
![image](https://user-images.githubusercontent.com/43658658/153896938-79ac11c7-b5e1-44f3-9ab4-0c1f942ae805.png)
