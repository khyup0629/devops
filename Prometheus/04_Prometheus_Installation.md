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

#  - job_name: node-exporter
#    scrape_interval: 15s
#    metrics_path: /metrics
#    static_configs:
#      - targets: [ 'node-exporter:9100' ]
#
#  - job_name: nginx-prometheus-exporter
#    scrape_interval: 15s
#    metrics_path: /metrics
#    static_configs:
#      - targets: [ 'nginx-prometheus-exporter:9113' ]
#
#  # http://localhost:9115/probe?module=http_2xx&target=http://host.docker.internal:9090
#  - job_name: 'blackbox-http-2xx'
#    metrics_path: /probe
#    params:
#      module: [ http_2xx ]
#    static_configs:
#      - targets:
#          - http://host.docker.internal:9090
#          - http://host.docker.internal:3000
#          - http://host.docker.internal:8080
#    relabel_configs:
#      - source_labels: [ __address__ ]
#        target_label: __param_target
#      - source_labels: [ __param_target ]
#        target_label: instance
#      - target_label: __address__
#        replacement: blackbox-exporter:9115
#
#  - job_name: sample-python
#    scrape_interval: 15s
#    metrics_path: /metrics
#    static_configs:
#      - targets: [ 'host.docker.internal:8080' ]

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
![image](https://user-images.githubusercontent.com/43658658/153999770-f53ce3ce-651c-4d4f-b11c-e64eaf997ea1.png)   
![image](https://user-images.githubusercontent.com/43658658/153999705-af62f3ed-8ebf-477b-925f-b625d734f8e4.png)   
- 그라파나 페이지의 **Data sources**의 설정을 담당합니다.

```
docker-compose up -d
```

```
docker-compose ps
```

`<호스트IP주소>:3000`으로 그라파나가 잘 설치되었는지 접속해봅니다.   
![image](https://user-images.githubusercontent.com/43658658/153975971-17c9b5a3-da61-4d3c-85b9-8dc219453e1d.png)

## node exporter 설치

```
cd /devops_prometheus/compose-files/node-exporter
```

```
vim docker-compose.yml
```

#### docker-compose.yml

``` python
version: '3.8'
services:
  node-exporter:
    container_name: node-exporter
    image: prom/node-exporter:latest
    ports:
      - "9101:9100"

networks:
  default:
    external:
      name: monitoring
```

```
docker-compose up -d
```

```
docker-compose ps
```

`curl` 명령어로 API 호출을 통해 node-exporter의 매트릭을 볼 수 있습니다.   
```
curl -v http://localhost:9101/metrics
```   
![image](https://user-images.githubusercontent.com/43658658/153983395-be15b02d-8a7b-4919-a1b1-70bdd1220802.png)

프로메테우스의 config 파일에 node-exporter에 대한 내용을 추가합니다.   
```
cd ../../config/prometheus
vim prometheus.yml
```

#### prometheus.yml

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
```   
- 같은 커스텀 네트워크로 묶었기 때문에 타겟을 `node-exporter`로 서비스 네임을 적어줘도 무방합니다.   
![image](https://user-images.githubusercontent.com/43658658/153984159-ac30515b-acdd-491c-8bb0-af27c3c1dacb.png)

프로메테우스의 config 내용 변경을 적용합니다.   
```
curl -XPOST -v http://localhost:9090/-/reload
```

## 그라파나 대시보드 임포트

구글링해서 `Grafana Dashboard`를 검색합니다.   

또는

=> [그라파나 대시보드 샘플](https://grafana.com/grafana/dashboards/)

위 사이트에서 원하는 샘플 대시보드를 클릭합니다.   
![image](https://user-images.githubusercontent.com/43658658/153999122-ebb99627-8790-48b2-b335-0e6b308435ad.png)

ID를 복사합니다.   
![image](https://user-images.githubusercontent.com/43658658/153999052-94d7e74a-5dc0-41a3-8d76-42131d1ec337.png)

그라파나 페이지에서 import를 합니다.   
![image](https://user-images.githubusercontent.com/43658658/153999220-fb115e4c-f0a2-462c-b25e-8b37740e56da.png)

ID를 입력하고 `Load`를 누릅니다.   
![image](https://user-images.githubusercontent.com/43658658/153999315-5344520a-9655-4b11-97a4-d1f98bcf9d51.png)

데이터 소스는 프로메테우스를 선택합니다.   
![image](https://user-images.githubusercontent.com/43658658/153999404-51ccd8d8-7dd3-4c03-94c6-aa5aaad87022.png)

대시보드 샘플이 임포트 되었습니다.   
![image](https://user-images.githubusercontent.com/43658658/153999450-901a3ea6-8bbf-4e41-bc70-032fbdbf8b53.png)

## nginx-prometheus-exporter 설치

nginx의 매트릭을 프로메테우스가 이해하기 위해서는 nginx-prometheus-exporter를 설치해야 합니다.

먼저 nginx 컨테이너를 올리고 nginx-prometheus-exporter 컨테이너를 실행합니다.   
```
cd /devops_prometheus/compose-files/nginx
vim docker-compose.yml
```

#### docker-compose.yml

``` python
version: '3.8'
services:
  nginx:
    container_name: nginx
    image: nginx:latest
    ports:
      - "8080:80"
    volumes:
      - ../../config/nginx/nginx.conf:/etc/nginx/nginx.conf
      - ../../config/nginx/logs:/var/log/nginx

  nginx-prometheus-exporter:
    container_name: nginx-prometheus-exporter
    image: nginx/nginx-prometheus-exporter:latest
    ports:
      - "9113:9113"
    command: -nginx.scrape-uri http://nginx/metrics -web.telemetry-path=/metrics

  prometheus-nginxlog-exporter:
    container_name: prometheus-nginxlog-exporter
    image: quay.io/martinhelmich/prometheus-nginxlog-exporter
    ports:
      - "4040:4040"
    volumes:
      - ../../config/prometheus-nginxlog-exporter/prometheus-nginxlog-exporter.yml:/etc/prometheus-nginxlog-exporter.yml
      - ../../config/nginx/logs:/var/log/nginx
    command: '-config-file /etc/prometheus-nginxlog-exporter.yml'

networks:
  default:
    external:
      name: monitoring
```   
- `-nginx.scrape-uri http://nginx/metrics` : `http://nginx/metrics`를 스크랩해서 프로메테우스가 이해할 수 있도록 변경합니다.
- `-web.telemetry-path=/metrics` : 스크랩한 매트릭을 외부로 노출하는 경로.   

nginx의 매트릭이 `http://nginx/metrics` 경로로 제공되도록 하기 위해서는 `nginx.conf` 파일을 설정해주어야 합니다.   
```
cd ../../config/nginx
vim nginx.conf
```

#### nginx.conf

``` python
user  nginx;
worker_processes  1;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log         /var/log/nginx/access.log  main;
    sendfile           on;
    keepalive_timeout  60;

    server {
        listen 80;
        location / {
            root   /usr/share/nginx/html;
            index  index.html index.htm;
        }

        location /metrics {
            stub_status on;
            access_log off;
            allow all;
        }
    }
}
```   
- `location /metrics`, `stub_status on;` : `http://nginx/metrics`의 경로로 nginx 상태 제공을 허락합니다.   

```
docker-compose up -d
docker-compose ps
```

```
curl http://localhost:8080
```

`<호스트IP주소>:8080/metrics` 경로로 접속하면 nginx 매트릭이 출력됩니다.   
```
curl -v http://localhost:8080/metrics
```
![image](https://user-images.githubusercontent.com/43658658/154012243-c9554f94-3c70-4b6b-b494-70c0203effde.png)

`<호스트IP주소>:9113/metrics` 경로로 접속하면 `http://<호스트IP주소>:8080/metrics`를 스크랩한 뒤 프로메테우스가 이해할 수 있도록 변환한 매트릭이 보여집니다.   
![image](https://user-images.githubusercontent.com/43658658/154012124-92242c83-c944-4d79-bb4e-e85beb27eb11.png)

nginx-prometheus-exporter를 프로메테우스의 타겟으로 반영하기 위해 `prometheus.yml` 파일을 수정합니다.   
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
```

```
curl -XPOST -v http://localhost:9090/-/reload
```

## nginx-prometheus-exporter를 위한 그라파나 대시보드 구성

구글링해서 `Grafana Dashboard`를 검색합니다.   

또는

=> [그라파나 대시보드 샘플](https://grafana.com/grafana/dashboards/)

![image](https://user-images.githubusercontent.com/43658658/154013602-12bbed54-cdec-43bb-a823-bd685509bf94.png)   
![image](https://user-images.githubusercontent.com/43658658/154013634-48185b80-7767-4273-b181-6dd52b5269be.png)   
![image](https://user-images.githubusercontent.com/43658658/154013704-ac2cb402-daad-4f32-8ff4-3e24e020229c.png)   
![image](https://user-images.githubusercontent.com/43658658/154013761-b9e5fb75-bb69-4432-8e6b-049d90544a3f.png)   
![image](https://user-images.githubusercontent.com/43658658/154013966-3861dc75-6059-40e4-938f-c3a9b0716e98.png)

tip) 그라파나 대시보드를 구성할 때 PromQL을 모두 구성하는 것은 사실상 **비효율적**입니다.   
샘플들을 **적절하게 가공**해서 사용하도록 합시다.

## blackbox-exporter 설치

java, spring, kotlin, flask 등과 같은 언어들이 동작하는 **워크로드**를 모니터링할 때 이용합니다.

```
cd /devops_prometheus/compose-files/blackbox-exporter
vim docker-compose.yml
```

#### docker-compose.yml

``` python
version: '3.8'
services:
  black-exporter:
    container_name: blackbox-exporter
    image: prom/blackbox-exporter:master
    ports:
      - "9115:9115"
    volumes:
      - ../../config/blackbox-exporter/blackbox.yml:/config/blackbox.yml

networks:
  default:
    external:
      name: monitoring
```

```
cd ../../config/blackbox-exporter
vim blackbox.yml
```

#### blackbox.yml

``` python
modules:
  http_2xx:
    http:
      no_follow_redirects: false
      preferred_ip_protocol: ip4
      valid_http_versions:
        - HTTP/1.1
        - HTTP/2
      valid_status_codes: [ ]
    prober: http
    timeout: 5s
```

```
docker-compose up -d
docker-compose ps
```

```
cd ../prometheus
vim prometheus.yml
```

#### prometheus.yml

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
```

```
curl -XPOST -v http://localhost:9090/-/reload
```

![image](https://user-images.githubusercontent.com/43658658/154036630-86580b06-d69f-462a-bfad-59ec9eae3631.png)

마찬가지로 grafana dashboard로 접속해서 blackbox-exporter와 관련된 샘플을 그라파나에 임포트합니다.   
![image](https://user-images.githubusercontent.com/43658658/154037116-0006ed6e-3172-42e6-a308-faca2485c11c.png)




