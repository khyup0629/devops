# 프로메테우스 설치

우분투 18.04 환경에 Docker를 설치하고 컨테이너로 프로메테우스를 실행해보겠습니다.

=> [Docker 설치 방법]()

> <h3>1. 서비스 디렉토리 만들기</h3>

디렉토리 구성은 아래와 같습니다.
![image](https://user-images.githubusercontent.com/43658658/153972808-3e8c4e86-1950-450c-a99c-c3eebffbc0d7.png)

```
cd /
git clone https://github.com/dev-chulbuji/devops_prometheus.git
```

devops_prometheus > compose-files > prometheus > docker-compose.yml

```
cd /devops_prometheus/compose-files/prometheus
```

> <h3>2. docker-compose, prometheus.yml 파일 구성</h3>

```
vim docker-compose.yml
```

``` python
version: '3.8'
services:
  prometheus:
    container_name: prom
    image: prom/prometheus:latest
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--storage.tsdb.retention=1h'
      - '--storage.tsdb.retention.size=1TB'
      - '--storage.tsdb.wal-compression'
      - '--web.enable-lifecycle'
      - '--web.console.libraries=/usr/share/prometheus/console_libraries'
      - '--web.console.templates=/usr/share/prometheus/consoles'
    volumes:
      - ../../config/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml
      - ./rules:/etc/prometheus/rules
    ports:
      - "9090:9090"

networks:
  default:
    external:
      name: monitoring
```   
- 프로메테우스의 설정 파일의 경로는 `/etc/prometheus/prometheus.yml`이고, Docker Host의 `prometheus.yml` 파일을 마운트 시켜줍니다.
- 마찬가지로 rules의 경로 역시 `/etc/prometheus/rules`이고, `/devops_prometheus/compose-files/prometheus/rules`를 마운트 시켜줍니다.

```
cd /devops_prometheus/config/prometheus
vim prometheus.yml
```

``` python
global:
  scrape_interval:     15s
  scrape_timeout:      10s
  evaluation_interval: 1m
  external_labels:
    monitor: 'dev-prometheus'
  query_log_file: /etc/prometheus/query.log

# rule file list evaluated by `global.evaluation_interval`
rule_files:
  - /etc/prometheus/rules/*.yaml

alerting:
  alertmanagers:
  - scheme: http
    api_version: v2
    path_prefix: /
    static_configs:
    - targets:
      - "alertmanager_1:9082"
      - "alertmanager_2:9084"

scrape_configs:
  - job_name: prometheus
    scrape_interval: 15s
    metrics_path: /metrics
    static_configs:
      - targets: [ 'localhost:9090' ]

  - job_name: node-exporter
    scrape_interval: 15s
    metrics_path: /metrics
    static_configs:
      - targets: [ 'node-exporter:9100' ]

  - job_name: nginx-prometheus-exporter
    scrape_interval: 15s
    metrics_path: /metrics
    static_configs:
      - targets: [ 'nginx-prometheus-exporter:9113' ]

  # http://localhost:9115/probe?module=http_2xx&target=http://host.docker.internal:9090
  - job_name: 'blackbox-http-2xx'
    metrics_path: /probe
    params:
      module: [ http_2xx ]
    static_configs:
      - targets:
          - http://host.docker.internal:9090
          - http://host.docker.internal:3000
          - http://host.docker.internal:8080
    relabel_configs:
      - source_labels: [ __address__ ]
        target_label: __param_target
      - source_labels: [ __param_target ]
        target_label: instance
      - target_label: __address__
        replacement: blackbox-exporter:9115

  - job_name: sample-python
    scrape_interval: 15s
    metrics_path: /metrics
    static_configs:
      - targets: [ 'host.docker.internal:8080' ]

#  - job_name: 'dj-custom'
#    scrape_interval: 10s
#    scrape_timeout: 10s
#    metrics_path: /metrics
#    scheme: http
#    http_sd_configs:
#      - follow_redirects: false
#        refresh_interval: 1s
#        url: http://sdapp:8080/targets

#  - job_name: 'dj-custom-file-sd'
#    file_sd_configs:
#      - files:
#          - /etc/prometheus/sd/dj_custom.json
#        refresh_interval: 10s
```

> <h3>3. docker-compose로 컨테이너 실행</h3>

`/devops_prometheus/compose-files/prometheus` 경로에서 `docker-compose up -d`을 실행시킵니다.   
```
cd /devops_prometheus/compose-files/prometheus
docker-compose up -d
```

```
docker-compose ps
```

> <h3>4. 프로메테우스 설치 확인</h3>

`<호스트IP주소>:9090`으로 접속해서 프로메테우스가 잘 설치되었는지 확인합니다.   
![image](https://user-images.githubusercontent.com/43658658/153974097-363c8b18-f86e-4be0-a85b-b9e2b8bb2325.png)

## 그라파나 설치

```
cd /devops_prometheus/compose-files/grafana
```

```
vim docker-compose.yml
```

#### docker-compose.yml

``` python
version: '3.8'
services:
  grafana:
    container_name: grafana
    image: grafana/grafana:latest
    ports:
      - "3000:3000"
    volumes:
      - ../../config/grafana/datasource.yml:/etc/grafana/provisioning/datasources/datasource.yml
    environment:
      GF_RENDERING_SERVER_URL: "http://renderer:8081/render"
      GF_RENDERING_CALLBACK_URL: "http://grafana:3000/"
      GF_LOG_FILTERS: "rendering:debug"
      GF_USERS_DEFAULT_THEME: "light"
      GF_AUTH_ANONYMOUS_ORG_ROLE: "Admin"
      GF_AUTH_ANONYMOUS_ENABLED: "true"
  renderer:
    image: grafana/grafana-image-renderer:latest
    ports:
      - "8081:8081"
    environment:
      IGNORE_HTTPS_ERRORS: "true"

networks:
  default:
    external:
      name: monitoring
```   
- 그라파나의 설정 파일은 `/etc/grafana/provisioning/datasources/datasource.yml` 경로에 있습니다.

#### datasource.yml

``` python
# config file version
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    orgId: 1
    url: http://prometheus:9090
    basicAuth: false
    isDefault: false
    version: 1
    editable: false
```

```
docker-compose up -d
```

```
docker-compose ps
```

`<호스트IP주소>:3000`으로 그라파나가 잘 설치되었는지 접속해봅니다.   
![image](https://user-images.githubusercontent.com/43658658/153975971-17c9b5a3-da61-4d3c-85b9-8dc219453e1d.png)



