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

> <h3>이미지 검색</h3>

docker와 docker HOST가 제대로 동작 중인지 확인합니다.   
```
systemctl status docker   // docker는 대몬이기 때문에 systemctl 명령어로 동작 여부를 확인 가능합니다.
docker version            // 클라이언트와 서버가 모두 정상적으로 출력되면 docker HOST가 정상 동작.
```

![image](https://user-images.githubusercontent.com/43658658/152626665-431b0902-f0d9-4ebc-8ddd-ea10ca2bc18d.png)   
![image](https://user-images.githubusercontent.com/43658658/152626727-ed8ac482-5632-4ff5-80ac-1efdf24a22e2.png)

**nginx 컨테이너 이미지**를 **허브**에서 검색합니다.   
```
docker search nginx
```

![image](https://user-images.githubusercontent.com/43658658/152626809-1231f8cf-2752-4148-b16b-cecbfb372ff7.png)   

> <h3>이미지 다운로드 후 이미지 레이어 확인</h3>

`/var/lib/docker/overlay2` 경로에 컨테이너 이미지 레이어가 저장됩니다.   
```
cd /var/lib/docker
ls -l
```   
![image](https://user-images.githubusercontent.com/43658658/152626878-e3fe5e7a-46d8-4316-9310-3d9531688b96.png)
  
```
cd overlay2
ls -l
```   
![image](https://user-images.githubusercontent.com/43658658/152626991-0a8bef99-3ce3-4ea2-9336-b4e84ce91cd3.png)

현재 docker HOST에 저장된 이미지들을 확인하는 명령어는 `docker images`입니다.   
```
docker images
```   
![image](https://user-images.githubusercontent.com/43658658/152627023-4c8019e2-cead-4744-adaf-51dede6faf74.png)

이제 nginx 컨테이너 이미지를 다운로드 받아 보겠습니다.   
```
docker pull nginx
```   
![image](https://user-images.githubusercontent.com/43658658/152627064-d7b317c1-b3e1-45d6-9a47-a3f4d65ad5a9.png)   
- 빨간 네모 박스는 **총 6개**의 레이어가 있다는 의미입니다.

`docker images` 명령어로 검색해보면 nginx 이미지가 추가된 것을 확인할 수 있고,   
`/var/lib/nginx/overlay2` 경로의 내용을 보면, 6개의 레이어가 추가된 것을 확인할 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/152627132-460229d0-50b5-4a52-99ac-79e340a1921f.png)










