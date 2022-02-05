# 컨테이너 개념

![image](https://user-images.githubusercontent.com/43658658/152478476-f4cb49f8-95bd-473c-bb32-674036ed8988.png)   
컨테이너(Container) : 하나의 OS 커널에서 다른 프로세스의 영향을 받지 않고 독립적으로 실행되는 프로세스.

각 컨테이너는 CPU, Memory, Network, Disk를 할당 받음.

각 컨테이너는 서로 독립. Docker Daemon 하에서 각 컨테이너가 동작 가능.

## 용어

- Docker HOST : Docker Daemon이 동작되고 있는 시스템
- Docker Daemon : 도커 대몬(systemctl start docker로 실행 가능)
- Docker Client Command : docker 명령어
- Docker Hub : 여러 컨테이너 이미지가 저장되어 있는 외부 저장소

## 일반 빌드 앱과 컨테이너 빌드 앱의 차이

1. 컨테이너 앱의 경우 컨테이너만 확장/축소 가능.   
- 쓸데없이 컴퓨팅 리소스까지 확장할 필요가 없음.
2. 환경을 가리지 않고 컨테이너만 있다면 개발한 코드를 어느 곳에서든 빌드 가능.

## 컨테이너 이미지

컨테이너 이미지는 아래와 같은 형식으로 파일로 **Docker HOST 디스크**에 저장됩니다.   
![image](https://user-images.githubusercontent.com/43658658/152493138-b3ee100e-acd3-4243-8f3c-9137410d634b.png)   

## 컨테이너와 컨테이너 이미지

Docker HOST의 디스크에 저장된 **컨테이너 이미지**(파일)을 불러와 빌드를 해서 **컨테이너**(프로세스)로 만듭니다.   
![image](https://user-images.githubusercontent.com/43658658/152494146-f2e9da61-a520-403e-8890-36b054102f68.png)

## 컨테이너 동작방식

![image](https://user-images.githubusercontent.com/43658658/152495460-74591c30-2855-4f67-831d-95f090dcdc5f.png)   
1. `docker search nginx` : 원하는 **이미지**를 검색
2. `docker pull nginx:latest` : 허브에서 이미지를 **하드디스크**로 가져옵니다.
3. `docker run -d --name web -p 80:80 nginx:latest` : 이미지를 **컨테이너**로 올립니다.

안돼













