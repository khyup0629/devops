# 컨테이너 생성 및 배포

컨테이너는 **dockerfile**을 이용해서 빌드합니다.   
* **dockerfile** : 컨테이너를 만들 수 있도록 도와주는 명령어 집합

## Dockerfile 문법

=> [Dockerfile 기본 문법](https://majaegeon.github.io/Docker/2021-06-06-Dockerfile/)

hub.docker.com 사이트에서 컨테이너를 클릭하고 **dockerfile**을 해석해보면서 문법에 익숙해져야 합니다.

## 컨테이너 이미지 

1. **컨테이너 빌드용 디렉토리**를 만들고 그 안에서 작업합니다.   
```
mkdir build
cd build
```   
2. **소스 코드**를 작성합니다.   
```
vi hello.js
```
<hello.js 내용>     
![image](https://user-images.githubusercontent.com/43658658/152631801-77deb8d5-9bd2-4035-b5d7-5d8bbc75d586.png)

3. **dockerfile**을 작성합니다.   
```
vi dockerfile
```   
<dockerfile 내용>   
```
FROM node:12        // base 이미지를 명시합니다.
COPY hello.js /     // 소스 코드를 컨테이너의 최상위 디렉토리에 복사합니다.
CMD ['node', '/hello.js']     // 컨테이너가 실행될 때 작동할 명령어입니다.
```
4. dockerfile을 이용해 컨테이너를 빌드해서 **이미지 파일**로 만듭니다.   
```
docker build -t khyup:latest .        // khyup:latest라는 이름의 컨테이너 이미지를 만듭니다.
```   
- `-t` : 컨테이너에 <이름:태그>를 달아줍니다.
- `.`은 현재 경로가 작업 디렉토리라는 것을 의미합니다.

![image](https://user-images.githubusercontent.com/43658658/152632312-d323ab5a-de54-486b-8b2f-514fe9af43b9.png)   
- node.js 12버전을 pull합니다. 따라서 현재 docker HOST에는 node:12와 khyup 이미지 2개가 생성되었습니다.   
![image](https://user-images.githubusercontent.com/43658658/152632356-ed48f555-a4f9-4419-90ea-27bbdaf204dc.png)

> <h3>이미지 테스트</h3>

```
docker run --name web -d -p 8080:8080 khyup
docker ps
curl localhost:8080
```   
![image](https://user-images.githubusercontent.com/43658658/152633238-f0f250f9-f3a4-4ef4-b233-3199595f691b.png)

실행되고 있는 컨테이너를 중지합니다.   
```
docker stop web
```

## 우분투 기반의 웹 서버 만들기

```
cd
mkdir webserver
cd webserver
vim dockerfile
```   
<dockerfile 내용>   
```
FROM ubuntu 18.04             // 우분투 18.04 버전이 베이스 이미지입니다.
LABEL maintainer="bllu <khyup0629@gmail.com>"       // 컨테이너에 대한 메타데이터 작성입니다. 키=값 형식으로 작성합니다.
RUN apt-get update \          // 이미지가 빌드될 때 RUN 별로 shell 명령어가 실행되며 이미지 레이어를 만듭니다.
  && apt-get install -y apache2 \
  && echo "TEST WEB" > /var/www/html/index.html
EXPOSE 80                     // 열어줄 포트를 설정합니다.
CMD ["/usr/sbin/apache2ctl", "-DFOREGROUND"]        // apache2ctl 대몬을 컨테이너가 실행될 때 시작합니다.
```   
![image](https://user-images.githubusercontent.com/43658658/152632912-bf2599b0-1576-426e-bc84-73ddd0ecaaa6.png)

이미지를 빌드합니다.   
```
docker build -t webserver:khyup .
```   
![image](https://user-images.githubusercontent.com/43658658/152633053-cc92353b-bc15-468e-b981-d47822c948c1.png)      
이미지를 빌드할 때 RUN이 실행되며, 아파치 패키지가 설치되는 것을 확인할 수 있습니다. 

> <h3>이미지 테스트</h3>

이미지를 컨테이너로 올립니다.   
```
docker run -d -p 80:80 webserver:khyup
```

`docker ps` 명령어를 통해 컨테이너가 정상적으로 실행되고 있는지 확인합니다.   
```
docker ps
```   
![image](https://user-images.githubusercontent.com/43658658/152633006-dad0f7d4-ae8f-4e7b-9152-e72713881b11.png)

정상적으로 실행되고 있는 것을 확인할 수 있습니다.
```
curl localhost:80
```   
![image](https://user-images.githubusercontent.com/43658658/152633111-509f049f-54f3-4609-8dfc-94d9b585bdd5.png)

## 컨테이너 배포

컨테이너를 허브에 배포하는 방법을 알아봅시다.   

1. **docker hub**로 로그인합니다.   
(미리 docker hub 계정을 생성해야 합니다)   
```
docker login
```   
![image](https://user-images.githubusercontent.com/43658658/152633346-b6649e94-92a2-4c82-9882-a7bc3a20df3c.png)

2. 이미지의 이름을 변경합니다.   
```
docker tag khyup <계정ID>/khyup
docker tag webserver:khyup <계정ID>/webserver:khyup
```   
도커 허브에 `push`할 때는 반드시 이미지 이름 앞에 **계정 ID**가 붙어야 합니다.   
(개인 리포지토리에 컨테이너가 업로드됩니다)   
![image](https://user-images.githubusercontent.com/43658658/152633458-7682854b-172d-4969-a7ec-5863d41188b3.png)   
- ID가 **동일**하고 이름이 다른 2개의 이미지가 생성되었습니다.

3. 빌드한 컨테이너 이미지를 허브에 `push`합니다.   
```
docker push <컨테이너 이미지 이름>
```   
![image](https://user-images.githubusercontent.com/43658658/152633509-2c598d53-fef1-4da8-89a3-2cfc2570bf68.png)

4. hub.docker.com 에 접속해서 **개인 리포지토리**를 확인합니다.   
![image](https://user-images.githubusercontent.com/43658658/152633544-de0eef07-beb8-4c92-9891-3cc0fc8c8a75.png)























