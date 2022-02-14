# Docker Compose

여러 컨테이너를 일괄적으로 정의하고 실행할 수 있는 툴

여러 컨테이너의 실행을 설정하고 한데 모아 `.yaml` 파일로 저장.

## Docker Compose 설치

=> [Docker Compose 설치 방법](https://docs.docker.com/compose/install/)

Docker Compose의 최신 버전을 설치합니다.   
```
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```

**실행 권한**을 줍니다.   
```
sudo chmod +x /usr/local/bin/docker-compose
```

**Docker compose**가 잘 설치되었는지 확인합니다.   
```
docker-compose version
```   
![image](https://user-images.githubusercontent.com/43658658/153803937-eec695a9-8d94-499f-b6d6-73f8028c0fcf.png)

## Docker Compose 문법

```
version: "3.9"
    
services:
  db:
    image: mysql:5.7
    volumes:
      - db_data:/var/lib/mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: somewordpress
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: wordpress
    
  wordpress:
    depends_on:
      - db
    image: wordpress:latest
    volumes:
      - wordpress_data:/var/www/html
    ports:
      - "8000:80"
    restart: always
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress
      WORDPRESS_DB_NAME: wordpress
volumes:
  db_data: {}
  wordpress_data: {}
```

- `version` : 버전 3, 2, 1이 있고 버전마다 사용할 수 있는 문법이 다릅니다.
- `services` : 컴포즈를 이용해 실행할 컨테이너 옵션을 정의
- `build` : 컨테이너 빌드
- `image` : 컴포즈를 통해 실행할 이미지를 지정
- `command` : 컨테이너에서 실행될 명령어 지정
- `port` : 컨테이너가 공개하는 포트 나열
- `link` : 다른 컨테이너와 연계할 때 연계할 컨테이너 지정
- `expose` : 포트를 링크로 연계된 컨테이너에게만 공개할 포트
- `volumes` : 컨테이너에 볼륨 마운트
- `environment` : 컨테이너 실행할 때 적용시킬 환경 변수
- `restart` : 컨테이너가 종료될 때 ㅈ거용할 restart 정책
  * `no` : 재시작 되지 않음.
  * `always` : 컨테이너를 수동으로 끄기 전까지 항상 재시작.
  * `on-failure` : 오류가 있을 시 재시작
- `depends_on` : `depends_on` 안에 정의된 컨테이너가 먼저 실행됩니다.

## Docker Compose 명령어

`docker-compose` 커멘드로 시작합니다.

- `up` : 컨테이너 생성/시작
    - `up -d` : 백그라운드로 생성
- `-f <.yml 파일>` : yaml 파일 실행으로 컨테이너 생성
- `ps` : 컨테이너 목록 표시
- `logs <서비스 이름>` : 컨테이너 로그 출력
- `run <서비스이름> <실행 명령어>` : 현재 실행중인 컨테이너에 <실행 명령어>를 전달.
- `start` : 컨테이너 시작
- `stop` : 컨테이너 정지
- `restart` : 컨테이너 재시작
- `pause` : 컨테이너 일시 정지
- `unpause` : 컨테이너 재개
- `port` : 공개 포트 번호 표시
- `config` : 구성 확인
- `kill` : 실행 중인 컨테이너 강제 정지
- `rm` : 컨테이너 삭제
- `down` : 리소스 삭제

## 빌드에서 운영까지

=> [Docker Compose를 활용한 예제](https://docs.docker.com/compose/gettingstarted/)

> <h3>1. 서비스 디렉토리 생성</h3>

```
mkdir composetest
cd composetest
vim app.py
```

<app.py>   
```
import time

import redis
from flask import Flask

app = Flask(__name__)
cache = redis.Redis(host='redis', port=6379)

def get_hit_count():
    retries = 5
    while True:
        try:
            return cache.incr('hits')
        except redis.exceptions.ConnectionError as exc:
            if retries == 0:
                raise exc
            retries -= 1
            time.sleep(0.5)

@app.route('/')
def hello():
    count = get_hit_count()
    return 'Hello World! I have been seen {} times.\n'.format(count)
```

빌드할 때 `requirements.txt`를 참조해 라이브러리를 설치합니다.   
(dockerfile에서 RUN 커맨드를 이용해 해당 내용을 구현합니다)   
```
vim requirements.txt
```

<requirements.txt>   
```
flask
redis
```

> <h3>2. dockerfile 생성</h3>

```
vim dockerfile
```

```
# syntax=docker/dockerfile:1
FROM python:3.7-alpine
WORKDIR /code
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0
RUN apk add --no-cache gcc musl-dev linux-headers
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
EXPOSE 5000
COPY . .
CMD ["flask", "run"]
```

> <h3>3. docker-compose.yml 생성</h3>

```
vim docker-compose.yml
```

```
version: "3.9"
services:
  web:
    build: .
    ports:
      - "8000:5000"
  redis:
    image: "redis:alpine"
```

> <h3>4. docker-compose으로 컨테이너 빌드 및 실행</h3>

```
docker-compose up
```

웹 브라우저에서 `172.16.0.202:8000`으로 접속하면 아래 내용이 표시됩니다.   
![image](https://user-images.githubusercontent.com/43658658/153805490-cfaadd05-6dba-4b85-ad58-45a9f1e2a878.png)

새로고침하면 숫자가 1씩 상승합니다.

> <h3>5. 기존의 yaml 파일을 수정</h3>

먼저 [Ctrl] + [c] 로 포그라운드로 실행되고 있는 app.py를 중지합니다.

이제 yaml 파일을 수정합니다.   
```
vim docker-compose.yml
```   

```
version: "3.9"
services:
  web:
    build: .
    ports:
      - "8000:5000"
    volumes:
      - .:/code
    environment:
      FLASK_ENV: development
  redis:
    image: "redis:alpine"
```   
- `volumes`에서 마운트 설정을 합니다.
    - `app.py`가 들어있는 현재 디렉토리를 컨테이너 내부 `/code`에 마운트하여 이미지를 다시 빌드하지 않고도 컨테이너 내부 코드가 수정됩니다.
- `environment` 키에서 `FLASK_ENV` 키를 `development`로 설정해 **개발 모드**로 설정하면, **변경된 코드가 바로 로드**됩니다.

> <h3>6. 백그라운드 모드로 재실행</h3>

이번에는 docker-compose를 백그라운드 모드로 실행합니다.   
```
docker-compose up -d
```   

```
docker-compose ps
```   
![image](https://user-images.githubusercontent.com/43658658/153805925-946fee8d-5e0e-42d5-9f05-8ebce53f99f5.png)

> <h3>7. app.py 내용 수정</h3>

```
vim app.py
```

맨 아래에 `Hello World!`를 `Hello Docker!`로 수정합니다.   
```
import time

import redis
from flask import Flask

app = Flask(__name__)
cache = redis.Redis(host='redis', port=6379)

def get_hit_count():
    retries = 5
    while True:
        try:
            return cache.incr('hits')
        except redis.exceptions.ConnectionError as exc:
            if retries == 0:
                raise exc
            retries -= 1
            time.sleep(0.5)

@app.route('/')
def hello():
    count = get_hit_count()
    return 'Hello Docker! I have been seen {} times.\n'.format(count)
```

`172.16.0.202:8000`으로 접속하면 수정사항이 바로 적용되어 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/153806395-57228379-8553-4d17-8fd5-352c3fe9d1a6.png)

> <h3>8. scale up</h3>

`scale` 명령을 사용해 컨테이너를 확장할 수 있습니다.   
```
docker-compose scale redis=3
```   

```
docker-compose ps
```   
![image](https://user-images.githubusercontent.com/43658658/153807534-9cf09644-34dc-405d-a51e-c2e5e0367072.png)

> <h3>9. flask의 환경 변수 확인하기</h3>

env는 flask의 환경 변수를 확인하는 명령어입니다.   

`docker-compose run <실행되고 있는 컨테이너 이름> <실행 명령어>`를 이용해 환경 변수를 확인할 수 있습니다.
```
docker-compose run web env
```   
![image](https://user-images.githubusercontent.com/43658658/153808538-4290afa2-e27c-4346-9d2c-5a59120c1fd0.png)

> <h3>10. 로그 확인하기</h3>

```
docker-compose logs web
```   
![image](https://user-images.githubusercontent.com/43658658/153808642-018b5696-bce8-4785-b53d-3906aef7f02b.png)

> <h3>11. 컨테이너 중지</h3>

```
docker-compose stop
```

```
docker-compose ps
```   
![image](https://user-images.githubusercontent.com/43658658/153809064-8cad2e1a-e8cd-42a1-aa02-bfb6dfd4178f.png)

> <h3>12. 컨테이너 종료</h3>

```
docker-compose down
```   
![image](https://user-images.githubusercontent.com/43658658/153809086-dceeab3c-1acc-432c-94a6-b63543123213.png)

## MySQL을 사용하는 Wordpress 운영

=> [튜토리얼 사이트](https://docs.docker.com/samples/wordpress/)

> <h3>1. 서비스 디렉토리 생성</h3>

```
mkdir my_wordpress
cd my_wordpress
```

> <h3>2. docker-compose.yml 파일 작성</h3>

```
vim docker-compose.yml
```

```
version: "3.9"
    
services:
  db:
    image: mysql:5.7
    volumes:
      - db_data:/var/lib/mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: somewordpress
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: wordpress
    
  wordpress:
    depends_on:
      - db
    image: wordpress:latest
    volumes:
      - wordpress_data:/var/www/html
    ports:
      - "8000:80"
    restart: always
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress
      WORDPRESS_DB_NAME: wordpress
volumes:
  db_data: {}
  wordpress_data: {}
```   
- `db_data`와 `wordpress_data` 디렉토리는 Docker Host의 `/var/lib/docker/volumes` 경로 내에 UUID 대신 `my_wordpress_db_data`와 `my_wordpress_wordpress_data`로 마운트 되어 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/153812684-c433a494-befa-4f80-af0f-8cc75f96f5fa.png)   
    * Docker Host의 `/db_data`, `/wordpress_data`에 마운트되어 있지 않습니다.
    * wordpress와 mysql이 연동되어 `db_data`에 `wordpress`가 있는 것을 확인할 수 있습니다.
- mysql의 환경 변수에서 `MYSQL_DATABASE`, `MYSQL_USER`, `MYSQL_PASSWORD`를 wordpress의 환경 변수 `WORDPRESS_DB_NAME`, `WORDPRESS_DB_USER`, `WORDPRESS_DB_PASSWORD`에 각각 매칭시켜줍니다.

> <h3>3. docker-compose로 컨테이너 실행</h3>

```
docker-compose up -d
```

```
docker-compose ps
```

`172.16.0.202:8000`으로 접속하면 아래와 같이 워드프레스 설치 화면이 나타납니다.   
![image](https://user-images.githubusercontent.com/43658658/153811251-d825c1b6-ae40-4f23-84dc-b8db65f4823d.png)





