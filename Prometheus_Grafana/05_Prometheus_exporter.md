## node exporter 사용하기

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

## nginx-prometheus-exporter 사용하기

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

## blackbox-exporter 사용하기

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

## prometheus-flask-exporter 사용하기

**python flask**에서 사용할 수 있는 **라이브러리 형태**의 프로메테우스 exporter 사용 방법입니다.

=> [prometheus-flask-exporter 사용 깃허브](https://github.com/rycus86/prometheus_flask_exporter)

**API 레벨**에서 flask를 이용해 기능을 구현했다고 했을 때 각 함수 단의 지표(ex. HTTP request)를 보고 싶을 때 이용합니다.

- 파이썬에서 `from prometheus_flask_exporter import PrometheusMetrics`로 임포트합니다.

> <h3>디폴트 매트릭</h3>

- `flask_http_request_duration_seconds` : flask HTTP 요청에 대한 응답 시간을 초단위로 나타낸 매트릭
- `flask_http_request_total` : HTTP 요청 전체 수
- `flask_http_request_exceptions_total` : HTTP 요청이 실패한 수
- `flask_exporter_info` : Prometheus-flask-exporter에 대한 information

> <h3>디폴트 매트릭 등록</h3>

디폴트 매트릭을 추가로 등록하고 싶으면, `metrics.register_default` 함수를 이용합니다.

``` python
metrics.register_default(
    metrics.counter(
        'by_path_counter', 'Request count by request paths',
        labels={'path': lambda: request.path}
    )
)
```   
- `metrics.counter`는 **counter 매트릭**을 의미합니다.

> <h3>여러 함수에서 같은 종류의 매트릭 보기</h3>

**counter 매트릭**을 여러 함수에서 보고 싶다면,   
**변수로 등록**한 뒤 `@<변수>`의 형식으로 함수 위에 써줍니다.   
``` python
app = Flask(__name__)
metrics = PrometheusMetrics(app)

by_path_counter = metrics.counter(
    'by_path_counter', 'Request count by request paths',
    labels={'path': lambda: request.path}
)

@app.route('/simple')
@by_path_counter
def simple_get():
    pass
    
@app.route('/plain')
@by_path_counter
def plain():
    pass
    
@app.route('/not/tracked/by/path')
def not_tracked_by_path():
    pass
```

> <h3>특정 함수 매트릭 보기 싫어</h3>

특정 함수에 대해 매트릭을 보기 싫다면,   
함수 위에 `@metrics.exclude_all_metrics()`를 써줍니다.

> <h3>매트릭 기록하지마</h3>

특정 함수에 대해 매트릭을 기록하지 않고 싶다면,   
함수 위에 `@metrics.do_not_track()`를 써줍니다.

> <h3>테스트</h3>

리눅스에서 아래와 같은 내용의 `app.py` 파이썬 파일을 만듭니다.   
``` python
from flask import Flask, jsonify, request
from prometheus_flask_exporter import PrometheusMetrics
from random import randrange
import time


def create_app():
  app = Flask(__name__)

  metrics = PrometheusMetrics(app)
  metrics.info('app_info', 'Application info', version='1.0.0')

  metrics.register_default(
    metrics.counter(
      'by_path_counter', 'Request count by request paths',
      labels={'path': lambda: request.path}
    )
  )

  @app.route("/healthz")
  @metrics.exclude_all_metrics()
  def healthz():
    return {
      "status": 200,
      "message": "healthy"
    }

  @app.route("/hello")
  def hello():
    print("hello world")
    return jsonify({"message": "Hello world !!\n"}), 200

  @app.route("/hello/<username>")
  def hello_user(username):
    print("username: ", username)
    if username == 'slow':
      time.sleep(randrange(1, 5))
    return jsonify({"message": "Hello %s\n" % username}), 200

  return app


if __name__ == "__main__":
  app = create_app()
  app.run(host='0.0.0.0', port=8080)
```   

파이썬 인터프리터와 파이썬 모듈을 다운 받을 수 있는 패키지인 `pip`을 설치합니다.   
```
sudo apt install -y python3.8-venv
sudo apt install -y python3-pip
```

파이썬의 flask와 prometheus-flask-exporter 모듈을 설치합니다.   
```
pip install flask
pip install prometheus_flask_exporter
```

이제 파이썬 경로로 들어가 백그라운드로 실행합니다.   
```
python3 app.py &
```   
- `ps -ef | grep app.py`를 통해 백그라운드로 실행되고 있는지 확인할 수 있어요.
- 실행할 때 이미 사용중인 주소라는 에러가 발생 한다면 전에 nginx를 docker-compose로 실행했기 때문이에요.
- `cd /devops_prometheus/compose-files/nginx`로 들어가서 `docker-compose down`을 실행해주고 다시 `app.py`를 실행합니다.

`curl` 명령어로 접속해보면 프로메테우스 방식의 매트릭이 나타나는 것을 확인할 수 있습니다.   
```
curl -v localhost:8080/metrics
```   
![image](https://user-images.githubusercontent.com/43658658/154496148-27c3743e-399c-4351-b088-3e9cf3dffc45.png)

`watch` 명령어를 통해 HTTP 요청을 날려볼 수 있습니다.   
```
watch -n 1 curl -v localhost:8080/hello
```   
![image](https://user-images.githubusercontent.com/43658658/154496574-98fab63c-d91f-4619-a64b-077656a1d91d.png)   
- 1초마다 한 번씩 `localhost:8080/hello` 주소로 HTTP 요청을 날립니다.
- `app.py`의 `@app.route('/hello')` 밑의 함수가 실행됩니다.

웹 브라우저로 접속합니다.   
![image](https://user-images.githubusercontent.com/43658658/154497054-5866ced5-c2a6-4373-ae4b-2801a344c569.png)   
- 새로고침을 해보면 1초마다 매트릭이 변하는 것을 확인할 수 있어요.

> <h3>그라파나 대시보드로 나타내기</h3>

먼저 `rometheus.yml` 파일에 **8080 포트**에 대한 내용을 추가합니다.   

```
cd /devops_prometheus/config/prometheus
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
        
  - job_name: sample-python
    scrape_interval: 15s
    metrics_path: /metrics
    static_configs:
      - targets: [ '172.16.0.202:8080' ]
```   
- `172.16.0.202:8080`으로 설정한 이유는 `app.py`가 컨테이너 바깥(Docker Host)에서 구동되고 있기 때문입니다.
- `localhost`, `host.docker.internal`로 설정하면 **에러 발생**.

```
cd ../../compose-files/prometheus
docker-compose down; docker-compose up
```

=> [prometheus-flask-exporter 그라파나 대시보드 json 샘플](https://github.com/rycus86/prometheus_flask_exporter/blob/master/examples/sample-signals/grafana/dashboards/example.json)

위 깃허브 사이트로 접속해서 `json` 내용을 전체 복사합니다.   
![image](https://user-images.githubusercontent.com/43658658/154497722-01081336-46f2-4e99-a2db-4bfe9085b2a3.png)

그라파나 페이지로 접속해서 임포트합니다.   
![image](https://user-images.githubusercontent.com/43658658/154501121-96e23bc0-8423-4e73-8d54-cba52a0dcb58.png)   
![image](https://user-images.githubusercontent.com/43658658/154501191-d36bb931-c21c-4470-8f84-ca17955656d5.png)

모니터링이 잘 되고 있음을 볼 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/154508381-f8bf52e1-1d47-4716-a74f-f5cd8aea6833.png)




