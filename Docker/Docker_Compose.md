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
- `depends_on` : 컨테이너 간 종속성을 정의. 정의한 컨테이너가 먼저 동작해야 합니다.
