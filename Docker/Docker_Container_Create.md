# 컨테이너 만들기

컨테이너는 **dockerfile**을 이용해서 빌드합니다.   
* **dockerfile** : 컨테이너를 만들 수 있도록 도와주는 명령어 집합

## 만드는 과정

1. 컨테이너 빌드용 디렉토리를 만들고 그 안에서 작업합니다.   
```
mkdir build
cd build
```   
2. 소스 코드를 작성합니다.   
```
vi hello.js
```
3. dockerfile을 작성합니다.   
```
vi dockerfile
```   
<dockerfile 내용>   
```
FROM node:12
COPY hello.js /
CMD ['node', '/hello.js']
```
4. dockerfile을 이용해 컨테이너를 빌드해서 이미지 파일로 만듭니다.   
```
docker build -t hellojs:latest .        // hellojs:latest라는 이름의 컨테이너 이미지를 만듭니다. `.`은 현재 경로에 dockerfile이 있다는 것을 의미합니다.
```

## Dockerfile 문법

=> [Dockerfile 기본 문법](https://majaegeon.github.io/Docker/2021-06-06-Dockerfile/)

## 컨테이너 배포

컨테이너를 허브에 배포하는 방법을 알아봅시다.   






















