# 컨테이너 생성 및 배포

컨테이너는 **dockerfile**을 이용해서 빌드합니다.   
* **dockerfile** : 컨테이너를 만들 수 있도록 도와주는 명령어 집합

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
docker build -t khyup:latest .        // hellojs:latest라는 이름의 컨테이너 이미지를 만듭니다.
```   
- `-t` : 컨테이너에 이름과 태그를 달아줍니다.
- `.`은 현재 경로가 작업 디렉토리라는 것을 의미합니다.

![image](https://user-images.githubusercontent.com/43658658/152632312-d323ab5a-de54-486b-8b2f-514fe9af43b9.png)   
- node.js 12버전을 pull합니다. 따라서 현재 docker HOST에는 node:12와 khyup 이미지 2개가 생성되었습니다.   
![image](https://user-images.githubusercontent.com/43658658/152632356-ed48f555-a4f9-4419-90ea-27bbdaf204dc.png)

## Dockerfile 문법

=> [Dockerfile 기본 문법](https://majaegeon.github.io/Docker/2021-06-06-Dockerfile/)

hub.docker.com 사이트에서 컨테이너를 클릭하고 **dockerfile**을 해석해보면서 문법에 익숙해져야 합니다.

## 컨테이너 배포

컨테이너를 허브에 배포하는 방법을 알아봅시다.   

먼저 docker HUB로 로그인합니다.   
```
docker login
```

빌드한 컨테이너 이미지를 허브에 `push`합니다.   
```
docker push <컨테이너 이미지 이름>
```























