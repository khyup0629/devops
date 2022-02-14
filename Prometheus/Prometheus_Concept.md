# 프로메테우스

## 프로메테우스 아키텍쳐

![image](https://user-images.githubusercontent.com/43658658/153833386-7bde0dc0-f0f9-4a70-96ed-1060b9bf635b.png)

> <h3>Prometheus Server</h3>

- 프로메테우스 서버는 TSDB(Time Series DB)라는 LevelDB를 가지고 있습니다.
- 데이터는 Node에 있는 HDD/SDD에 저장됩니다.

> <h3>jobs/Exporters</h3>

- 프로메테우스 서버가 **pull 방식**으로 jobs/exporters에서 매트릭을 가져갑니다.

> <h3>Service Discovery</h3>

- 프로메테우스가 **타겟을 찾는 기술**입니다.
- **kubernetes, file_sd**
- **file_sd** 파일에 타겟을 명시할 수 있습니다.

> <h3>Pushgateway</h3>

- **push 방식** 지원
- cronjob 같은 **수행 시간이 작은 서버**의 경우 서버가 금방 죽습니다.
- 그렇게 되면 프로메테우스가 **지속적으로 pull 방식으로 매트릭을 스크래핑 할 수 없습니다.**
- 그래서 pushgateway에 이러한 서버들의 데이터를 쌓아두고 프로메테우스가 pull 방식으로 pushgateway의 매트릭을 스크래핑합니다.
- 여러 타겟이 외부에 있고, 타겟에 방화벽을 일일이 지정할 수 없을 때 타겟의 매트릭을 pushgateway에 하나로 모아서 프로메테우스가 가져가는 방법으로도 이용할 수 있습니다.

> <h3>Alertmanager</h3>

- alerting을 담당합니다.
- Alertmanager가 여러 앱에 경보를 보냅니다.

> <h3>Data visualization</h3>

- Prometheus Web UI, Grafana, API Clients

## 매트릭 타입

> <h3>Counter</h3>

- **항상 증가**하는 값에 대한 매트릭 타입.
- reset하면 0

> <h3>gauge</h3>

- **up/down**이 가능한 매트릭 타입
- ex) CPU / Memory 사용량

> <h3>Histogram</h3>

- 응답 크기, 요청 기간 등, **start~end 단위의 주기 내**에서 값의 증감을 관찰할 수 있는 매트릭
- 전체 합계를 확인할 수 있는 매트릭
  
> <h3>Summary</h3>

- **Histogram과 같은 역할**을 하는 매트릭 종류.
- 다른 점은 특정 시간 내의 전체 값이나 양을 구성하기 편하다는 점입니다.
  
## 프로메테우스 표현 언어

> <h3>샘플(Sample)</h3>

`process_cpu_seconds_total{instance="localhost:9090", job="prometheus"}                1.09`는 하나의 **샘플**입니다.

```
`process_cpu_seconds_total{instance="localhost:9090", job="prometheus"}                1.09`   
     (metric name)                  (label key=value)                                metric value(scalar)
```

> <h3>인스턴트 벡터(Instant Vector)</h3>

- **동일 시간대**의 **샘플들의 묶음**
- **Operation**을 적용할 수 있습니다.
  - ex) sum, min, max, avg, stddev(분산), stdvar(표준편차), count, count_values, bottomk, topk, quantile

> <h3>레인지 벡터(Range Vector)</h3>

- **하나의 샘플 내**에 **여러 metric value의 묶음**

## 프로메테우스 쿼리(PromQL)

> <h3>인스턴트 벡터 selector</h3>

- 인스턴트 벡터의 label에 대해 **원하는 value**로 필터링을 하는 쿼리
- 중괄호(`{}`)에 입력합니다.
- ex) prometheus_engine_query_duration_seconds_count{instance='<ip 주소:포트번호>'}

> <h3>레인지 벡터 selector</h3>

- 레인지 벡터의 label에 시간을 입력해서 원하는 개수 만큼의 **metric value**를 select하는 쿼리
- 대괄호(`[]`)에 입력합니다.
- ex) prometheus_engine_query_duration_seconds_count[1m]

> <h3>offset</h3>

- 현재 시점에서 **몇 시간 전의 샘플**들을 select하는 쿼리
- ex) prometheus_engine_query_duration_seconds_count offset 1m

> <h3>by (label)</h3>

- **operation과 연계**하여 label을 그룹별로 볼 수 있습니다.
- ex) count (prometheus_engine_query_duration_seconds_count) **by** (instance)

> <h3>without (label)</h3>

- 명시한 label을 제외한 label들을 그룹별로 묶은 값을 쿼리합니다.
- ex) count (prometheus_engine_query_duration_seconds_count) **without** (instance)

> <h3>join</h3>

각 샘플들의 metric value를 label 별로 사칙연산을 수행할 수 있습니다.

사칙연산을 수행하는 샘플의 개수가 많은 것을 **카디널리티가 높다**라고 표현합니다.

> <h3>on과 ignoring</h3>

- on(label) : 명시한 label만 가지고 join
- ignoring(label) : 명시한 label를 무시하고 join

> <h3>group_left, group_right</h3>

카디널리티가 높은 인스턴트 벡터를 join의 왼쪽에 둘 경우 **group_left**를 써줍니다.   
카디널리티가 높은 인스턴트 벡터를 join의 오른쪽에 둘 경우 **group_right**를 써줍니다.

ex) prometheus_engine_query_duration_seconds_count / on (instance, job) **group_left** prometheus_engine_queries_concurrent_max

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
