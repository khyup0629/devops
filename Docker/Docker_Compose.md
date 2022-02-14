# Docker Compose

여러 컨테이너를 일괄적으로 정의하고 실행할 수 있는 툴

여러 컨테이너의 실행을 설정하고 한데 모아 `.yaml` 파일로 저장.

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
- `run <서비스이름> <실행 명령어>` : 컨테이너 실행
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

## Docker Compose 파일로 컨테이너 실행

1. 서비스 디렉토리 생성

```
mkdir webserver
cd webserver
```

2. docker-compose.yml 생성

```
cat > docker-compose.yml
version: '3'
services:
    web:
        image: httpd:latest
        ports:
            - "80:80"
        links:
            - mysql:db
        command: apachectl -DFOREGROUND
    mysql:
        image: mysql:latest
        command:mysqld
        environment:
```

3. docker-compose 명령어

## 빌드에서 운영까지

1. 서비스 디렉토리 생성
2. dockerfile 생성
3. docker-compose.yml 생성
4. docker-compose 
